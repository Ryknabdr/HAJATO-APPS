import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../routes/app_routes.dart';

import 'package:hajato/app/core/constants/api_config.dart';

class VerifyOtpController extends GetxController {
  final otpController = TextEditingController();
  final isLoading = false.obs;

  late final String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments['email'] ?? '';
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().isEmpty) {
      Get.snackbar('Gagal', 'OTP wajib diisi');
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otpController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

if (response.statusCode == 200) {
  Get.snackbar('Berhasil', data['message']);

  Get.toNamed(
    AppRoutes.resetPassword,
    arguments: {
      'email': email,
      'otp': otpController.text.trim(),
    },
  );
} else {
        Get.snackbar('Gagal', data['message']);
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}