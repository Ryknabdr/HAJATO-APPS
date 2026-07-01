import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/models.dart';
import '../../../data/repositories/dummy_data.dart';
import '../../notifikasi/views/notifikasi_view.dart';
import '../../notifikasi/bindings/notifikasi_binding.dart';
import '../../../routes/app_routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_config.dart';

class HomeController extends GetxController {
  final searchQuery = ''.obs;
  final selectedCategory = ''.obs;

  final userName = 'Pengguna'.obs;

  final RxList<VendorModel> allVendors = <VendorModel>[].obs;
  final RxList<VendorModel> featuredVendors = <VendorModel>[].obs;

  final currentNavIndex = 0.obs;
  final unreadNotifications = 0.obs;

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

  @override
  void onInit() {
    super.onInit();
    loadUserName();
    fetchPublicVendors();
    fetchUnreadNotifications();
  }

  @override
  void onReady() {
    super.onReady();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('name');

    if (savedName != null && savedName.trim().isNotEmpty) {
      userName.value = savedName;
      return;
    }

    final args = Get.arguments;
    if (args != null && args is Map) {
      userName.value = args['name'] ?? 'Pengguna';
    }
  }

  Future<void> fetchPublicVendors() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/vendor/public-vendors'),
      );

      print('PUBLIC VENDORS STATUS: ${response.statusCode}');
      print('PUBLIC VENDORS BODY: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List list = data['data'] ?? [];

        final mappedList = list.map((e) {
          Map<String, dynamic> vendorMap = Map<String, dynamic>.from(e);
          
          String rawImage = vendorMap['image_url'] ?? vendorMap['image'] ?? '';
          
          if (rawImage.isNotEmpty && !rawImage.startsWith('http')) {
            String fullImageUrl = '${ApiConfig.baseUrl}/uploads/$rawImage';
            vendorMap['image'] = fullImageUrl;
            vendorMap['image_url'] = fullImageUrl;
          }
          return vendorMap;
        }).toList();

        allVendors.assignAll(
          mappedList.map((e) => VendorModel.fromJson(e)).toList(),
        );

        // Sinkronisasi pemanggilan filter awal berdasarkan query pencarian terbaru
        onSearch(searchQuery.value);
      }
    } catch (e) {
      print('FETCH PUBLIC VENDORS ERROR: $e');
    }
  }

  Future<void> refreshHome() async {
    selectedCategory.value = '';
    searchQuery.value = '';
    await loadUserName();
    await fetchPublicVendors();
    await fetchUnreadNotifications();
    print('HOME REFRESH: Data berhasil diperbarui & filter kategori di-reset');
  }

  // ── 🟢 FIX UTAMA: LOGIKA PENCARIAN REAL-TIME VENDOR BERDASARKAN NAMA ──
  void onSearch(String query) {
    searchQuery.value = query;

    if (query.trim().isEmpty) {
      // Jika kolom pencarian kosong, kembalikan ke kondisi filter kategori awal
      if (selectedCategory.value.isEmpty) {
        featuredVendors.assignAll(allVendors.where((v) => v.isFeatured).toList());
      } else {
        featuredVendors.assignAll(
          allVendors.where((v) => v.category == selectedCategory.value).toList(),
        );
      }
    } else {
      // Jika user sedang mengetik, lakukan saringan (filter) berdasarkan nama vendor (case-insensitive)
      // Filter juga mendeteksi status kategori yang sedang aktif ditekan oleh user
      List<VendorModel> filtered = allVendors.where((v) {
        final matchesName = v.name.toLowerCase().contains(query.toLowerCase());
        final matchesCategory = selectedCategory.value.isEmpty || v.category == selectedCategory.value;
        return matchesName && matchesCategory;
      }).toList();

      featuredVendors.assignAll(filtered);
    }
  }

  // ── 🟢 FIX UTAMA: SINKRONISASI KLIK KATEGORI DENGAN QUERY PENCARIAN ──
  void selectCategory(String cat) {
    selectedCategory.value = selectedCategory.value == cat ? '' : cat;
    // Jalankan ulang fungsi onSearch dengan query yang ada agar kombinasi filter berjalan beriringan
    onSearch(searchQuery.value);
  }

  void goToVendorList(String? category) {
    Get.toNamed(
      AppRoutes.vendorList,
      arguments: category,
    );
  }

  Future<void> goToVendorDetail(VendorModel vendor) async {
    await Get.toNamed(
      AppRoutes.vendorDetail,
      arguments: vendor,
    );
    await fetchPublicVendors();
  }

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
        Get.toNamed(AppRoutes.event);
        currentNavIndex.value = 0;
        break;

      case 3:
        await Get.toNamed(AppRoutes.profile);
        currentNavIndex.value = 0;
        loadUserName();
        break;
    }
  }

  Future<void> fetchUnreadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/notifications/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        unreadNotifications.value =
            data.where((notif) => notif['is_read'] == false).length;
      }
    } catch (e) {
      print('FETCH USER UNREAD NOTIFICATION ERROR: $e');
    }
  }

  void goToNotification() async {
    await Get.to(
      () => const NotifikasiView(),
      binding: NotifikasiBinding(),
      transition: Transition.rightToLeft,
    );
    fetchUnreadNotifications();
  }
}