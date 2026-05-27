import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_config.dart';
import '../../../data/models/models.dart';

class VendorBookingsController extends GetxController {
  final bookings = <BookingModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVendorBookings();
  }

  Future<void> fetchVendorBookings() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/booking/vendor-bookings'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('VENDOR BOOKINGS STATUS: ${response.statusCode}');
      print('VENDOR BOOKINGS BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        bookings.value = List<BookingModel>.from(
          data.map((x) => BookingModel.fromJson(x)),
        );
      }
    } catch (e) {
      print('VENDOR BOOKINGS ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

Future<void> completeBooking(String bookingId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/booking/complete/$bookingId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Berhasil',
        'Acara berhasil ditandai selesai',
        snackPosition: SnackPosition.BOTTOM,
      );

      fetchVendorBookings();
    } else {
      Get.snackbar(
        'Gagal',
        'Tidak bisa menyelesaikan acara',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    print('COMPLETE BOOKING ERROR: $e');
  }
}

}