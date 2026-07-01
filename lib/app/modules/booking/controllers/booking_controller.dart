import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_config.dart';

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

    final hour = selectedTime.value!.hour.toString().padLeft(2, '0');
    final minute = selectedTime.value!.minute.toString().padLeft(2, '0');

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
          colorScheme: const ColorScheme.light(primary: Color(0xFF4F6AF5)),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  Future<bool> checkAvailability() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/booking/check-availability'
          '?vendor_id=${vendor.id}'
          '&event_date=${selectedDate.value!.toIso8601String()}',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['available'] == false) {
          Get.snackbar(
            'Jadwal Tidak Tersedia',
            data['message'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );

          return false;
        }

        return true;
      }

      return false;
    } catch (e) {
      print('CHECK AVAILABILITY ERROR: $e');
      return false;
    }
  }

  Future<void> confirm() async {
    if (selectedDate.value == null) {
      Get.snackbar(
        'Peringatan',
        'Silakan pilih tanggal terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFBBF24),
        colorText: Colors.white,
      );
      return;
    }

    if (eventLocation.value.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Silakan isi lokasi acara',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFBBF24),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    final available = await checkAvailability();
    isLoading.value = false;

    if (!available) {
      return;
    }

    // ── 🟢 TRIK AMAN: AMBIL EVENT_ID YANG AKTIF DI SINI ──
    final prefs = await SharedPreferences.getInstance();
    String activeEventId = prefs.getString('selected_event_id') ?? '';
    print("[DEBUG HAJATO] Mengirim event_id ke halaman payment: $activeEventId");

    Get.toNamed(
      AppRoutes.payment,
      arguments: {
        'vendor': vendor,
        'package': package,
        'date': selectedDate.value,
        'notes': notes.value,
        'totalPrice': package.price,
        'time': formattedTime,
        'location': eventLocation.value,
        'event_id': activeEventId, // ── 🟢 DATA ID ACARA SEKARANG IKUT DIKIRIM KE PAYMENT VIEW
      },
    );
  }
}