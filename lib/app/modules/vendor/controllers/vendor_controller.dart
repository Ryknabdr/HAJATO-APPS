import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/dummy_data.dart';
import '../../../routes/app_routes.dart';

class VendorController extends GetxController {
  final RxList<VendorModel> vendors = <VendorModel>[].obs;
  final RxList<VendorModel> filteredVendors = <VendorModel>[].obs;
  final selectedCategory = 'Semua'.obs;
  final sortBy = 'rating'.obs;
  final isGridView = false.obs;
  final searchQuery = ''.obs;

  final categories = ['Semua', 'Fotografer', 'Catering', 'Tenda', 'Makeup', 'Sound System', 'Wedding Organizer'];

  late VendorModel selectedVendor;
  late ServicePackage selectedPackage;

  @override
  void onInit() {
    super.onInit();
    vendors.assignAll(DummyData.vendors);
    filteredVendors.assignAll(DummyData.vendors);

    final arg = Get.arguments;
    if (arg is String && arg.isNotEmpty) {
      selectCategory(arg);
    }
    if (arg is VendorModel) {
      selectedVendor = arg;
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
    var list = DummyData.vendors.where((v) {
      final matchCat = selectedCategory.value == 'Semua' || v.category == selectedCategory.value;
      final matchSearch = searchQuery.value.isEmpty || v.name.toLowerCase().contains(searchQuery.value.toLowerCase());
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
    Get.toNamed(AppRoutes.booking, arguments: {'vendor': selectedVendor, 'package': package});
  }

  void toggleView() => isGridView.value = !isGridView.value;
}
