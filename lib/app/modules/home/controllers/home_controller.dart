import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/models.dart';
import '../../../data/repositories/dummy_data.dart';
import '../../notifikasi/views/notifikasi_view.dart';
import '../../notifikasi/bindings/notifikasi_binding.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final searchQuery = ''.obs;
  final selectedCategory = ''.obs;

  final userName = 'Pengguna'.obs;

  final RxList<VendorModel> allVendors = <VendorModel>[].obs;
  final RxList<VendorModel> featuredVendors = <VendorModel>[].obs;

  final currentNavIndex = 0.obs;

  final categories = [
    {'label': 'Fotografer', 'icon': '📷'},
    {'label': 'Catering', 'icon': '🍽️'},
    {'label': 'Tenda', 'icon': '⛺'},
    {'label': 'Makeup', 'icon': '💄'},
    {'label': 'Sound System', 'icon': '🎵'},
    {'label': 'Wedding Organizer', 'icon': '💍'},
  ];

  @override
  void onInit() {
    super.onInit();

    loadUserName();

    allVendors.assignAll(DummyData.vendors);

    featuredVendors.assignAll(
      DummyData.vendors.where((v) => v.isFeatured).toList(),
    );
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

  void onSearch(String query) {
    searchQuery.value = query;
  }

  void selectCategory(String cat) {
    selectedCategory.value =
        selectedCategory.value == cat ? '' : cat;

    featuredVendors.assignAll(
      selectedCategory.value.isEmpty
          ? DummyData.vendors.where((v) => v.isFeatured).toList()
          : DummyData.vendors.where((v) => v.category == cat).toList(),
    );
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
    currentNavIndex.value = index;

    switch (index) {
      case 1:
        Get.toNamed(AppRoutes.vendorList);
        break;

      case 2:
        Get.toNamed(AppRoutes.event);
        break;

      case 3:
        await Get.toNamed(AppRoutes.profile);
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