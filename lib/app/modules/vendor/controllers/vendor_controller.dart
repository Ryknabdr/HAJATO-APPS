import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_config.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';

class VendorController extends GetxController {
  final RxList<VendorModel> vendors = <VendorModel>[].obs;
  final RxList<VendorModel> filteredVendors = <VendorModel>[].obs;

  final selectedCategory = 'Semua'.obs;
  final sortBy = 'rating'.obs;
  final isGridView = false.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

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

  late VendorModel selectedVendor;
  late ServicePackage selectedPackage;

  @override
  void onInit() {
    super.onInit();

    final arg = Get.arguments;

    fetchVendors().then((_) {
      if (arg is String && arg.isNotEmpty) {
        selectCategory(arg);
      }

      if (arg is VendorModel) {
        selectedVendor = arg;
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
          final imageName = e['image_url'] ?? '';

          final imageUrl = imageName.toString().isNotEmpty
              ? '${ApiConfig.baseUrl}/uploads/$imageName'
              : '';

          final List galleryData = e['gallery'] ?? [];

          final gallery = galleryData
              .where((g) => g != null && g.toString().isNotEmpty)
              .map<String>((g) => '${ApiConfig.baseUrl}/uploads/$g')
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
  image: image.toString().isNotEmpty
      ? '${ApiConfig.baseUrl}/uploads/$image'
      : '',
);
          }).toList();

          return VendorModel(
            id: e['id'] ?? '',
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
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Gagal mengambil vendor',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('FETCH PUBLIC VENDORS ERROR: $e');

      Get.snackbar(
        'Error',
        'Tidak dapat mengambil data vendor',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
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
      final matchCat =
          selectedCategory.value == 'Semua' || v.category == selectedCategory.value;

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
    Get.toNamed(AppRoutes.vendorDetail, arguments: vendor);
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
    await fetchVendors();
  }
}