import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';

class QrController extends GetxController {
  final currentGuest = Rx<GuestModel?>(null);
  final scanResult = ''.obs;
  final scanStatus = ''.obs; // success, error, idle

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is GuestModel) {
      currentGuest.value = arg;
    }
  }

  void onScanDetect(String code) {
    if (scanStatus.value == 'success') return;
    scanResult.value = code;
    if (code.startsWith('HAJATO-')) {
      scanStatus.value = 'success';
      Get.find<QrController>(); // trigger update
    } else {
      scanStatus.value = 'error';
    }
    Future.delayed(const Duration(seconds: 3), () => scanStatus.value = 'idle');
  }

  void goToScanner() => Get.toNamed(AppRoutes.qrScanner);
}
