import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/api_config.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../../notifikasi/bindings/notifikasi_binding.dart';
import '../../notifikasi/views/notifikasi_view.dart';

class HomeController extends GetxController {
  // ============================================================
  // SEARCH DAN FILTER
  // ============================================================

  final searchQuery = ''.obs;
  final selectedCategory = ''.obs;

  // ============================================================
  // DATA USER
  // ============================================================

  final userName = 'Pengguna'.obs;

  // ============================================================
  // DATA VENDOR
  // ============================================================

  final RxList<VendorModel> allVendors = <VendorModel>[].obs;
  final RxList<VendorModel> featuredVendors = <VendorModel>[].obs;

  // ============================================================
  // SLIDER VENDOR
  // ============================================================

  final PageController vendorSliderController = PageController();

  final currentVendorSlide = 0.obs;

  Timer? vendorSliderTimer;

  // ============================================================
  // DATA YOUTUBE
  // ============================================================

  final RxList<Map<String, dynamic>> latestYoutubeVideos =
      <Map<String, dynamic>>[].obs;

  final isLoadingYoutube = false.obs;

  // ============================================================
  // NAVIGASI DAN NOTIFIKASI
  // ============================================================

  final currentNavIndex = 0.obs;
  final unreadNotifications = 0.obs;

  // ============================================================
  // KATEGORI VENDOR
  // ============================================================

  final categories = [
    {'label': 'Fotografi', 'icon': '📷'},
    {'label': 'Dekorasi', 'icon': '✨'},
    {'label': 'Catering', 'icon': '🍽️'},
    {'label': 'Musik', 'icon': '🎵'},
    {'label': 'Makeup', 'icon': '💄'},
    {'label': 'Wedding Organizer', 'icon': '💍'},
    {'label': 'MC', 'icon': '🎤'},
    {'label': 'Venue', 'icon': '🏛️'},
    {'label': 'Sound System', 'icon': '🔊'},
  ];

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    loadUserName();
    fetchPublicVendors();
    fetchUnreadNotifications();
    fetchLatestYoutubeVideos();
  }

  @override
  void onReady() {
    super.onReady();

    loadUserName();
  }

  // ============================================================
  // MENGAMBIL NAMA USER
  // ============================================================

  Future<void> loadUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? savedName = prefs.getString('name');

    if (savedName != null && savedName.trim().isNotEmpty) {
      userName.value = savedName;
      return;
    }

    final dynamic args = Get.arguments;

    if (args != null && args is Map) {
      userName.value = (args['name'] ?? 'Pengguna').toString();
    }
  }

  // ============================================================
  // MENGAMBIL VENDOR PUBLIK
  // ============================================================

  Future<void> fetchPublicVendors() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/vendor/public-vendors'),
      );

      print('PUBLIC VENDORS STATUS: ${response.statusCode}');

      print('PUBLIC VENDORS BODY: ${response.body}');

      final dynamic decodedData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> list = decodedData['data'] ?? [];

        final List<Map<String, dynamic>> mappedList = list.map((item) {
          final Map<String, dynamic> vendorMap = Map<String, dynamic>.from(
            item,
          );

          final String rawImage =
              (vendorMap['image_url'] ?? vendorMap['image'] ?? '').toString();

          if (rawImage.isNotEmpty && !rawImage.startsWith('http')) {
            final String cleanImage = rawImage.startsWith('/')
                ? rawImage.substring(1)
                : rawImage;

            final String fullImageUrl =
                '${ApiConfig.baseUrl}/uploads/$cleanImage';

            vendorMap['image'] = fullImageUrl;
            vendorMap['image_url'] = fullImageUrl;
          }

          return vendorMap;
        }).toList();

        allVendors.assignAll(
          mappedList.map((item) => VendorModel.fromJson(item)).toList(),
        );

        // Memperbarui daftar vendor unggulan
        onSearch(searchQuery.value);

        // Mengatur ulang slider dari halaman pertama
        currentVendorSlide.value = 0;

        if (vendorSliderController.hasClients) {
          vendorSliderController.jumpToPage(0);
        }

        // Menjalankan slider otomatis
        startVendorSlider();
      }
    } catch (e) {
      print('FETCH PUBLIC VENDORS ERROR: $e');
    }
  }

  // ============================================================
  // SLIDER VENDOR OTOMATIS
  // ============================================================

  void startVendorSlider() {
    vendorSliderTimer?.cancel();

    if (allVendors.length <= 1) {
      return;
    }

    vendorSliderTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!vendorSliderController.hasClients || allVendors.isEmpty) {
        return;
      }

      final int nextPage = (currentVendorSlide.value + 1) % allVendors.length;

      vendorSliderController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void onVendorSlideChanged(int index) {
    currentVendorSlide.value = index;
  }

  // ============================================================
  // MENGAMBIL VIDEO YOUTUBE TERBARU
  // ============================================================

  Future<void> fetchLatestYoutubeVideos() async {
    try {
      isLoadingYoutube.value = true;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/youtube/latest?limit=3'),
      );

      print('YOUTUBE LATEST STATUS: ${response.statusCode}');

      print('YOUTUBE LATEST BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = Map<String, dynamic>.from(
          jsonDecode(response.body),
        );

        final List<dynamic> data = result['data'] ?? [];

        latestYoutubeVideos.assignAll(
          data.map((item) {
            return Map<String, dynamic>.from(item);
          }).toList(),
        );
      } else {
        latestYoutubeVideos.clear();
      }
    } catch (e) {
      latestYoutubeVideos.clear();

      print('FETCH LATEST YOUTUBE ERROR: $e');
    } finally {
      isLoadingYoutube.value = false;
    }
  }

  // ============================================================
  // MEMBUKA VIDEO YOUTUBE
  // ============================================================

  Future<void> openYoutubeVideo(String videoLink) async {
    final Uri? uri = Uri.tryParse(videoLink);

    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      Get.snackbar(
        'Link tidak valid',
        'Video tidak dapat dibuka.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    try {
      final bool berhasilDibuka = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!berhasilDibuka) {
        Get.snackbar(
          'Gagal membuka video',
          'Aplikasi YouTube atau browser tidak dapat dibuka.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Terjadi kesalahan',
        'Video tidak dapat dibuka.',
        snackPosition: SnackPosition.BOTTOM,
      );

      print('OPEN YOUTUBE ERROR: $e');
    }
  }

  // ============================================================
  // REFRESH BERANDA
  // ============================================================

  Future<void> refreshHome() async {
    selectedCategory.value = '';
    searchQuery.value = '';

    await loadUserName();
    await fetchPublicVendors();
    await fetchUnreadNotifications();
    await fetchLatestYoutubeVideos();

    print(
      'HOME REFRESH: Vendor, notifikasi, '
      'slider, dan video berhasil diperbarui',
    );
  }

  // ============================================================
  // PENCARIAN VENDOR
  // ============================================================

  void onSearch(String query) {
    searchQuery.value = query;

    List<VendorModel> result = [];

    if (query.trim().isEmpty) {
      if (selectedCategory.value.isEmpty) {
        // Tetap hanya mengambil vendor unggulan
        result = allVendors.where((vendor) => vendor.isFeatured).toList();
      } else {
        result = allVendors
            .where((vendor) => vendor.category == selectedCategory.value)
            .toList();
      }
    } else {
      final String normalizedQuery = query.trim().toLowerCase();

      result = allVendors.where((vendor) {
        final bool matchesName = vendor.name.toLowerCase().contains(
          normalizedQuery,
        );

        final bool matchesCategory =
            selectedCategory.value.isEmpty ||
            vendor.category == selectedCategory.value;

        return matchesName && matchesCategory;
      }).toList();
    }

    // Urutkan rating tertinggi ke terendah
    result.sort((vendorA, vendorB) {
      final int ratingComparison = vendorB.rating.compareTo(vendorA.rating);

      if (ratingComparison != 0) {
        return ratingComparison;
      }

      // Kalau rating sama, ulasan terbanyak lebih dulu
      return vendorB.reviewCount.compareTo(vendorA.reviewCount);
    });

    featuredVendors.assignAll(result);
  }

  // ============================================================
  // FILTER KATEGORI
  // ============================================================

  void selectCategory(String category) {
    selectedCategory.value = selectedCategory.value == category ? '' : category;

    onSearch(searchQuery.value);
  }

  // ============================================================
  // NAVIGASI VENDOR
  // ============================================================

  void goToVendorList(String? category) {
    Get.toNamed(AppRoutes.vendorList, arguments: category);
  }

  Future<void> goToVendorDetail(VendorModel vendor) async {
    await Get.toNamed(AppRoutes.vendorDetail, arguments: vendor);

    await fetchPublicVendors();
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  void changeNav(int index) async {
    if (index == 0) {
      currentNavIndex.value = 0;
      return;
    }

    currentNavIndex.value = index;

    switch (index) {
      case 1:
        await Get.toNamed(AppRoutes.vendorList);
        currentNavIndex.value = 0;
        break;

      case 2:
        await Get.toNamed(AppRoutes.event);
        currentNavIndex.value = 0;
        break;

      case 3:
        await Get.toNamed(AppRoutes.profile);
        currentNavIndex.value = 0;
        await loadUserName();
        break;
    }
  }

  // ============================================================
  // NOTIFIKASI
  // ============================================================

  Future<void> fetchUnreadNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/notifications/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        unreadNotifications.value = data
            .where((notification) => notification['is_read'] == false)
            .length;
      }
    } catch (e) {
      print('FETCH USER UNREAD NOTIFICATION ERROR: $e');
    }
  }

  Future<void> goToNotification() async {
    await Get.to(
      () => const NotifikasiView(),
      binding: NotifikasiBinding(),
      transition: Transition.rightToLeft,
    );

    await fetchUnreadNotifications();
  }

  // ============================================================
  // MEMBERSIHKAN CONTROLLER
  // ============================================================

  @override
  void onClose() {
    vendorSliderTimer?.cancel();
    vendorSliderController.dispose();

    super.onClose();
  }
}
