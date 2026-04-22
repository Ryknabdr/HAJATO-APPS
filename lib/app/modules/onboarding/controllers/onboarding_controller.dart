import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  void goToLogin() => Get.toNamed(AppRoutes.login);     // ← ubah ini
  void goToRegister() => Get.toNamed(AppRoutes.register); // ← dan ini
  void goToVendorLogin() => Get.toNamed(AppRoutes.vendorDashboard);
}
