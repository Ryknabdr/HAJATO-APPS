import 'package:get/get.dart';

import '../controllers/vendor_data_controller.dart';

class VendorDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorDataController>(
      () => VendorDataController(),
    );
  }
}