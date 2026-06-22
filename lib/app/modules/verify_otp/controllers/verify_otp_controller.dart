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
  late final String purpose;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};

    email = args['email'] ?? '';
    purpose = args['purpose'] ?? 'reset_password';
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().isEmpty) {
      Get.snackbar(
        'Gagal',
        'OTP wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (email.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Email tidak ditemukan',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final String endpoint = purpose == 'register'
          ? '/api/auth/verify-register-otp'
          : '/api/auth/verify-otp';

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otpController.text.trim(),
        }),
      );

      print("VERIFY OTP STATUS : ${response.statusCode}");
      print("VERIFY OTP BODY : ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          data['message'] ?? 'OTP berhasil diverifikasi',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        if (purpose == 'register') {
          Get.offAllNamed(AppRoutes.login);
        } else {
          Get.toNamed(
            AppRoutes.resetPassword,
            arguments: {
              'email': email,
              'otp': otpController.text.trim(),
            },
          );
        }
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'OTP tidak valid',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFFEDED),
          colorText: const Color(0xFF991F1F),
        );
      }
    } catch (e) {
      print("VERIFY OTP ERROR : $e");

      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEDED),
        colorText: const Color(0xFF991F1F),
      );
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