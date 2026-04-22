import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/dummy_data.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final searchQuery = ''.obs;
  final selectedCategory = ''.obs;
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
    allVendors.assignAll(DummyData.vendors);
    featuredVendors.assignAll(
        DummyData.vendors.where((v) => v.isFeatured).toList());
  }

  void onSearch(String query) => searchQuery.value = query;

  void selectCategory(String cat) {
    selectedCategory.value = selectedCategory.value == cat ? '' : cat;
    featuredVendors.assignAll(
      selectedCategory.value.isEmpty
          ? DummyData.vendors.where((v) => v.isFeatured).toList()
          : DummyData.vendors.where((v) => v.category == cat).toList(),
    );
  }

  void goToVendorList(String? category) =>
      Get.toNamed(AppRoutes.vendorList, arguments: category);

  void goToVendorDetail(VendorModel vendor) =>
      Get.toNamed(AppRoutes.vendorDetail, arguments: vendor);

  void changeNav(int index) {
    currentNavIndex.value = index;
    switch (index) {
      case 1:
        Get.toNamed(AppRoutes.vendorList);
        break;
      case 2:
        Get.toNamed(AppRoutes.event);
        break;
      case 3:
        Get.toNamed(AppRoutes.profile); 
        break;
    }
  }
}