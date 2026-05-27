import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';

class BookingController extends GetxController {
  late VendorModel vendor;
  late ServicePackage package;

  final selectedDate = Rx<DateTime?>(null);
  final selectedTime = Rx<TimeOfDay?>(null);
  final selectedPackageIndex = 0.obs;
  final notes = ''.obs;
  final eventLocation = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      vendor = args['vendor'] as VendorModel;
      package = args['package'] as ServicePackage;
    }
  }

String get formattedDate => selectedDate.value == null
    ? 'Pilih tanggal'
    : DateFormat('dd MMMM yyyy', 'id').format(selectedDate.value!);

String get formattedTime {
  if (selectedTime.value == null) {
    return 'Pilih jam';
  }

  final hour = selectedTime.value!.hour
      .toString()
      .padLeft(2, '0');

  final minute = selectedTime.value!.minute
      .toString()
      .padLeft(2, '0');

  return '$hour:$minute WIB';
}

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF4F6AF5)),
        ),
        child: child!,
      ),
    );
    if (picked != null) selectedDate.value = picked;
  }

  void pickTime(BuildContext context) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4F6AF5),
        ),
      ),
      child: child!,
    ),
  );

  if (picked != null) {
    selectedTime.value = picked;
  }
}

  void confirm() {
    if (selectedDate.value == null) {
      Get.snackbar(
        'Peringatan', 'Silakan pilih tanggal terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFBBF24),
        colorText: Colors.white,
      );
      return;
    }

    Get.toNamed(AppRoutes.payment, arguments: {
      'vendor': vendor,
      'package': package,
      'date': selectedDate.value,
      'notes': notes.value,
      'totalPrice': package.price,
      'time': formattedTime,
      'location': eventLocation.value,
    });
  }
}