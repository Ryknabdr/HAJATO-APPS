import 'package:get/get.dart';
import '../../../routes/app_routes.dart';


class OnboardingController extends GetxController {
  void goToLogin() => Get.toNamed(AppRoutes.login);

  void goToRegister() => Get.toNamed(AppRoutes.register);

  void goToVendorLogin() =>
      Get.toNamed(AppRoutes.vendorRegistration);
}