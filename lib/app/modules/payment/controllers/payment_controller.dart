import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../views/payment_webview_screen.dart';

import '../../../data/models/models.dart';
import '../../../core/constants/api_config.dart';

class PaymentController extends GetxController {
  late VendorModel vendor;
  late ServicePackage package;
  late DateTime eventDate;
  late String eventTime;
  late String eventLocation;
  late String notes;
  late int totalPrice;
  String? eventId; // ── 🟢 DEKLARASIKAN VARIABEL UNTUK MENAMPUNG EVENT_ID

  final isLoading = false.obs;
  final paymentSuccess = false.obs;
  String? bookingId;

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
    eventId = args['event_id'] as String?; // ── 🟢 TANGKAP DATA EVENT_ID DARI ARGUMENTS
  }

  String get formattedDate =>
      DateFormat('dd MMMM yyyy', 'id').format(eventDate);

  String get formattedPrice => NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(totalPrice);

  Future<bool> createBooking() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar('Error', 'Token tidak ditemukan, silakan login ulang');
        return false;
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
          'event_id': eventId, // ── 🟢 DIKIRIM KE BACKEND SEKARANG! BIAR GAK NULL LAGI
          'event_date': eventDate.toIso8601String(),
          'event_time': eventTime,
          'location': eventLocation,
          'notes': notes,
          'payment_method': 'midtrans',
          'payment_detail': 'midtrans',
          'total_price': totalPrice,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        bookingId = data['booking_id'];
        return true;
      }

      return false;
    } catch (e) {
      print('CREATE BOOKING ERROR: $e');
      return false;
    }
  }

  Future<void> payWithMidtrans() async {
    try {
      isLoading.value = true;

      final success = await createBooking();

      if (!success || bookingId == null) {
        Get.snackbar('Error', 'Booking gagal dibuat');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/payment/create/$bookingId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final redirectUrl = data['redirect_url'];
        
        // 🟢 1. IMPORT DAN PANGGIL SCREEN WEBVIEW BARU DI SINI, BOS!
        // Jangan lupa di bagian paling atas controller lo import filenya:
        // import '../views/payment_webview_screen.dart';
        
        final result = await Get.to(() => PaymentWebViewScreen(
              paymentUrl: redirectUrl,
              callbackUrl: "${ApiConfig.baseUrl}/api/payment/callback", // Sesuaikan URL callback Flask lo
            ));

        // 🟢 2. CEK JIKA USER SUKSES BAYAR DI WEBVIEW
        if (result == 'SUCCESS') {
          paymentSuccess.value = true;
          
          Get.snackbar(
            'Sukses',
            'Pembayaran berhasil terkonfirmasi!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Info',
            'Pembayaran belum diselesaikan atau dibatalkan.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
        
      } else {
        Get.snackbar('Gagal', 'Tidak dapat membuat transaksi Midtrans');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}