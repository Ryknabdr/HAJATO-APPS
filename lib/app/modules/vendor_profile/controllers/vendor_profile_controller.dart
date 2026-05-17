import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorProfileController extends GetxController {

  final vendorName = ''.obs;
  final vendorEmail = ''.obs;
  final vendorStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadVendorData();
  }

  Future<void> loadVendorData() async {

    final prefs = await SharedPreferences.getInstance();

    vendorName.value =
        prefs.getString('name') ?? 'Vendor';

    vendorEmail.value =
        prefs.getString('email') ?? '-';

    vendorStatus.value =
        prefs.getString('vendor_status') ?? 'pending';
  }

  Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    Get.offAllNamed('/login');
  }
}