import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_config.dart';
import '../../../data/models/models.dart';

class MyBookingsController extends GetxController {

  final bookings = <BookingModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }
  @override
  void onReady() {
    super.onReady();
    fetchBookings();
}

  Future<void> fetchBookings() async {

    try {

      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/booking/my-bookings'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('MY BOOKINGS STATUS: ${response.statusCode}');
      print('MY BOOKINGS BODY: ${response.body}');

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        bookings.value = List<BookingModel>.from(
          data.map((x) => BookingModel.fromJson(x)),
        );
      }

    } catch (e) {

      print('MY BOOKINGS ERROR: $e');

    } finally {

      isLoading.value = false;

    }
  }
  Future<void> submitReview({
  required String bookingId,
  required int rating,
  required String comment,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/reviews/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'booking_id': bookingId,
        'rating': rating,
        'comment': comment,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      Get.back();

      Get.snackbar(
        'Berhasil',
        data['message'] ?? 'Ulasan berhasil dikirim',
        snackPosition: SnackPosition.TOP,
      );

      await fetchBookings();
    } else {
      Get.snackbar(
        'Gagal',
        data['message'] ?? 'Gagal mengirim ulasan',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    print('SUBMIT REVIEW ERROR: $e');

    Get.snackbar(
      'Error',
      'Tidak dapat terhubung ke server',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
}