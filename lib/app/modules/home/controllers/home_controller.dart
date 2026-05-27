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
@override
void onInit() {
  super.onInit();

  loadUserName();

  fetchPublicVendors();
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

      allVendors.assignAll(
        list.map((e) => VendorModel.fromJson(e)).toList(),
      );

      featuredVendors.assignAll(
        allVendors.where((v) => v.isFeatured).toList(),
      );
    }
  } catch (e) {
    print('FETCH PUBLIC VENDORS ERROR: $e');
  }
}

  void onSearch(String query) {
    searchQuery.value = query;
  }

void selectCategory(String cat) {
  selectedCategory.value =
      selectedCategory.value == cat ? '' : cat;

  if (selectedCategory.value.isEmpty) {
    featuredVendors.assignAll(allVendors);
  } else {
    featuredVendors.assignAll(
      allVendors.where((v) => v.category == selectedCategory.value).toList(),
    );
  }
}
  void goToVendorList(String? category) {
    Get.toNamed(
      AppRoutes.vendorList,
      arguments: category,
    );
  }

  void goToVendorDetail(VendorModel vendor) {
    Get.toNamed(
      AppRoutes.vendorDetail,
      arguments: vendor,
    );
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
      await Get.toNamed(AppRoutes.event);
      currentNavIndex.value = 0;
      break;

    case 3:
      await Get.toNamed(AppRoutes.profile);
      currentNavIndex.value = 0;
      loadUserName();
      break;
  }
}

  void goToNotification() {
    Get.to(
      () => const NotifikasiView(),
      binding: NotifikasiBinding(),
      transition: Transition.rightToLeft,
    );
  }
}