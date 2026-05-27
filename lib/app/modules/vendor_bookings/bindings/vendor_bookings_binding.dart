import 'package:get/get.dart';

import '../controllers/vendor_bookings_controller.dart';

class VendorBookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorBookingsController>(
      () => VendorBookingsController(),
    );
  }
}
