import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/api_config.dart';
import '../../../data/models/models.dart';

class BookingDetailController extends GetxController {
  late BookingModel booking;

  @override
  void onInit() {
    super.onInit();
    booking = Get.arguments as BookingModel;
  }

  Future<void> payWithMidtrans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/payment/create/${booking.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final redirectUrl = data['redirect_url'];

        await launchUrl(
          Uri.parse(redirectUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Tidak dapat membuat pembayaran Midtrans',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );
    }
  }
}