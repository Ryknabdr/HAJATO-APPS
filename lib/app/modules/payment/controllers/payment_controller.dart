import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_config.dart';

class PaymentController extends GetxController {
  late VendorModel vendor;
  late ServicePackage package;
  late DateTime eventDate;
  late String eventTime;
  late String eventLocation;
  late String notes;
  late int totalPrice;

  final selectedMethod = ''.obs;
  final selectedBank = ''.obs;
  final selectedEwallet = ''.obs;
  final isLoading = false.obs;

  final banks = [
    {'id': 'bca', 'label': 'BCA', 'account': '1234567890', 'logo': '🏦'},
    {'id': 'bni', 'label': 'BNI', 'account': '0987654321', 'logo': '🏦'},
    {'id': 'bri', 'label': 'BRI', 'account': '1122334455', 'logo': '🏦'},
    {
      'id': 'mandiri',
      'label': 'Mandiri',
      'account': '5544332211',
      'logo': '🏦',
    },
  ];

  final ewallets = [
    {'id': 'gopay', 'label': 'GoPay', 'number': '08123456789', 'logo': '💚'},
    {'id': 'ovo', 'label': 'OVO', 'number': '08234567890', 'logo': '💜'},
    {'id': 'dana', 'label': 'DANA', 'number': '08345678901', 'logo': '💙'},
    {
      'id': 'shopeepay',
      'label': 'ShopeePay',
      'number': '08456789012',
      'logo': '🧡',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    vendor = args['vendor'] as VendorModel;
    package = args['package'] as ServicePackage;
    eventDate = args['date'] as DateTime;
    eventTime = args['time'] as String;
    eventLocation = args['location'] as String;
    notes = args['notes'] as String;
    totalPrice = args['totalPrice'] as int;
  }

  String get formattedDate =>
      DateFormat('dd MMMM yyyy', 'id').format(eventDate);

  String get formattedPrice => NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(totalPrice);

  bool get isValid {
    if (selectedMethod.value == 'transfer')
      return selectedBank.value.isNotEmpty;
    if (selectedMethod.value == 'ewallet')
      return selectedEwallet.value.isNotEmpty;
    if (selectedMethod.value == 'cod') return true;
    return false;
  }

  void selectMethod(String method) {
    selectedMethod.value = method;
    selectedBank.value = '';
    selectedEwallet.value = '';
  }

  Future<bool> createBooking() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Token tidak ditemukan, silakan login ulang',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      String paymentDetail = '';

      if (selectedMethod.value == 'transfer') {
        paymentDetail = selectedBank.value;
      } else if (selectedMethod.value == 'ewallet') {
        paymentDetail = selectedEwallet.value;
      } else {
        paymentDetail = 'cod';
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/booking/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'vendor_id': vendor.id,
          'vendor_name': vendor.name,
          'package_id': package.id,
          'package_name': package.name,
          'event_date': eventDate.toIso8601String(),
          'event_time': eventTime,
          'location': eventLocation,
          'notes': notes,
          'payment_method': selectedMethod.value,
          'payment_detail': paymentDetail,
          'total_price': totalPrice,
        }),
      );

      print('CREATE BOOKING STATUS: ${response.statusCode}');
      print('CREATE BOOKING BODY: ${response.body}');

      return response.statusCode == 201;
    } catch (e) {
      print('CREATE BOOKING ERROR: $e');
      return false;
    }
  }

  void pay() async {
    if (!isValid) {
      String msg = selectedMethod.value == 'transfer'
          ? 'Silakan pilih bank tujuan'
          : selectedMethod.value == 'ewallet'
          ? 'Silakan pilih e-wallet'
          : 'Silakan pilih metode pembayaran';
      Get.snackbar(
        'Peringatan',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFBBF24),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    final success = await createBooking();

    isLoading.value = false;

    if (!success) {
      Get.snackbar(
        'Error',
        'Booking gagal dibuat',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pembayaran Berhasil! 🎉'),
        content: Text(
          'Pesanan ${vendor.name} untuk ${package.name}\npada $formattedDate telah dikonfirmasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.offAllNamed(AppRoutes.home),
            child: const Text('Kembali ke Beranda'),
          ),
        ],
      ),
    );
  }
}
