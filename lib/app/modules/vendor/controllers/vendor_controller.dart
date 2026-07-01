import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_config.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan import Firestore ini

class VendorController extends GetxController {
  final RxList<VendorModel> vendors = <VendorModel>[].obs;
  final RxList<VendorModel> filteredVendors = <VendorModel>[].obs;

  final selectedCategory = 'Semua'.obs;
  final sortBy = 'rating'.obs;
  final isGridView = false.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final vendorReviews = <ReviewModel>[].obs;
  final detailRating = 0.0.obs;
  final detailReviewCount = 0.obs;

  final categories = [
    'Semua',
    'Fotografi',
    'Dekorasi',
    'Catering',
    'Musik',
    'Makeup',
    'Wedding Organizer',
    'MC',
    'Venue',
    'Sound System',
  ];

  final rxSelectedVendor = Rx<VendorModel?>(null);
  VendorModel get selectedVendor => rxSelectedVendor.value!;
  set selectedVendor(VendorModel v) => rxSelectedVendor.value = v;

  late ServicePackage selectedPackage;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;

    if (arg is VendorModel) {
      selectedVendor = arg;
    }

    fetchVendors().then((_) {
      if (arg is String && arg.isNotEmpty) {
        selectCategory(arg);
      }
    });
  }

  Future<void> fetchVendors() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/vendor/public-vendors'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List list = data['data'] ?? [];

        final loaded = list.map((e) {
          final imageName = e['image_url'] ?? e['image'] ?? '';

          final imageUrl = imageName.toString().isNotEmpty && !imageName.toString().startsWith('http')
              ? '${ApiConfig.baseUrl}/uploads/$imageName'
              : imageName.toString();

          final List galleryData = e['gallery'] ?? [];
          final gallery = galleryData
              .where((g) => g != null && g.toString().isNotEmpty)
              .map<String>((g) => g.toString().startsWith('http') ? g.toString() : '${ApiConfig.baseUrl}/uploads/$g')
              .toList();

          final List packagesData = e['packages'] ?? [];
          final packages = packagesData.map<ServicePackage>((p) {
            final image = p['image'] ?? '';
            return ServicePackage(
              id: p['id'] ?? '',
              name: p['name'] ?? '',
              category: p['category'] ?? '',
              description: p['description'] ?? '',
              price: p['price'] ?? 0,
              capacity: p['capacity'] ?? '',
              duration: p['duration'] ?? '',
              features: List<String>.from(p['features'] ?? []),
              image: image.toString().isNotEmpty && !image.toString().startsWith('http')
                  ? '${ApiConfig.baseUrl}/uploads/$image'
                  : image.toString(),
            );
          }).toList();

          return VendorModel(
            id: e['id'] ?? '',
            vendorUserId: e['vendor_user_id'] ?? '',
            name: e['name'] ?? '',
            category: e['category'] ?? '',
            description: e['description'] ?? '',
            rating: (e['rating'] ?? 0).toDouble(),
            reviewCount: e['review_count'] ?? 0,
            imageUrl: imageUrl,
            gallery: gallery,
            packages: packages,
            reviews: const [],
            location: e['location'] ?? '',
            startingPrice: e['starting_price'] ?? 0,
            isFeatured: e['is_featured'] ?? false,
          );
        }).toList();

        vendors.assignAll(loaded);
        _applyFilters();

        if (rxSelectedVendor.value != null) {
          final updated = vendors.firstWhereOrNull((v) => v.id == rxSelectedVendor.value!.id);
          if (updated != null) rxSelectedVendor.value = updated;
        }
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Gagal mengambil vendor',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('FETCH PUBLIC VENDORS ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchVendorReviews(String vendorId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/reviews/vendor/$vendorId'),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List reviews = data['data'] ?? [];
        vendorReviews.assignAll(
          reviews.map((e) {
            return ReviewModel(
              id: e['id'] ?? '',
              userName: e['customer_name'] ?? '',
              userAvatar: '',
              rating: (e['rating'] ?? 0).toDouble(),
              comment: e['comment'] ?? '',
              date: e['created_at'] ?? '',
            );
          }).toList(),
        );
      }
    } catch (e) {
      print('FETCH REVIEW ERROR: $e');
    }
  }

  Future<void> fetchVendorRating(String vendorId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/reviews/vendor-rating/$vendorId'),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        detailRating.value = (data['average_rating'] ?? 0).toDouble();
        detailReviewCount.value = data['total_reviews'] ?? 0;
      }
    } catch (e) {
      print('FETCH VENDOR RATING ERROR: $e');
    }
  }

  void selectCategory(String cat) {
    selectedCategory.value = cat;
    _applyFilters();
  }

  void onSearch(String q) {
    searchQuery.value = q;
    _applyFilters();
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    _applyFilters();
  }

  void _applyFilters() {
    var list = vendors.where((v) {
      final matchCat = selectedCategory.value == 'Semua' || v.category == selectedCategory.value;
      final keyword = searchQuery.value.toLowerCase();
      final matchSearch = keyword.isEmpty ||
          v.name.toLowerCase().contains(keyword) ||
          v.category.toLowerCase().contains(keyword) ||
          v.location.toLowerCase().contains(keyword);
      return matchCat && matchSearch;
    }).toList();

    if (sortBy.value == 'rating') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (sortBy.value == 'price_asc') {
      list.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
    } else if (sortBy.value == 'price_desc') {
      list.sort((a, b) => b.startingPrice.compareTo(a.startingPrice));
    }
    filteredVendors.assignAll(list);
  }

  void goToDetail(VendorModel vendor) {
    selectedVendor = vendor;
    fetchVendorReviews(vendor.id);
    fetchVendorRating(vendor.id);

    Get.toNamed(
      AppRoutes.vendorDetail,
      arguments: vendor,
    );
  }

  void goToBooking(ServicePackage package) {
    selectedPackage = package;
    Get.toNamed(
      AppRoutes.booking,
      arguments: {
        'vendor': selectedVendor,
        'package': package,
      },
    );
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
  }

  Future<void> refreshVendors() async {
    searchQuery.value = '';
    selectedCategory.value = 'Semua';
    await fetchVendors();
    print('VENDOR REFRESH: Seluruh data vendor berhasil di-update dari server Flask');
  }

  Future<void> goToChatVendor() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '';
    final userName = prefs.getString('name') ?? 'User';

    final vendorId = selectedVendor.id;
    final vendorUserId = selectedVendor.vendorUserId;
    final vendorName = selectedVendor.name;

    final chatId = ChatService.getChatId(
      userId: userId,
      vendorId: vendorId,
    );

    await ChatService.createOrUpdateChatRoom(
      chatId: chatId,
      userId: userId,
      userName: userName,
      vendorId: vendorId,
      vendorName: vendorName,
      lastMessage: '',
    );

    // ── 🟢 RESET ANGKA UNREAD USER DI FIRESTORE PAS MASUK DARI DETAIL VENDOR ──
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .update({
      'unread_user': 0,
    });

    Get.toNamed(
      AppRoutes.chatViewRoom,
      arguments: {
        'chat_id': chatId,
        'receiver_name': vendorName,
        'receiver_id': vendorUserId,
        'sender_id': userId,
        'sender_role': 'user',
      },
    );
  }
}