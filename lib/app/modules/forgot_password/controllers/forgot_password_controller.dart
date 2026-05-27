import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:hajato/app/core/constants/api_config.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final isLoading = false.obs;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }

    if (!GetUtils.isEmail(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/auth/forgot-password',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailController.text.trim(),
        }),
      );

      print("FORGOT PASSWORD STATUS : ${response.statusCode}");
      print("FORGOT PASSWORD BODY : ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          data['message'] ?? 'OTP berhasil dikirim',
          snackPosition: SnackPosition.TOP,
        );

        Get.toNamed(
          AppRoutes.verifyOtp,
          arguments: {
            'email': emailController.text.trim(),
          },
        );
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Gagal mengirim OTP',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("FORGOT PASSWORD ERROR : $e");

      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}