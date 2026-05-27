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
}