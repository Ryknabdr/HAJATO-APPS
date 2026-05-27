import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:hajato/app/core/constants/api_config.dart';
import '../../../routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  late final String email;
  late final String otp;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments['email'] ?? '';
    otp = Get.arguments['otp'] ?? '';
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }

    if (value != passwordController.text) {
      return 'Password tidak sama';
    }

    return null;
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'new_password': passwordController.text.trim(),
        }),
      );

      print("RESET PASSWORD STATUS : ${response.statusCode}");
      print("RESET PASSWORD BODY : ${response.body}");

      final data = jsonDecode(response.body);

if (response.statusCode == 200) {
  Get.snackbar(
    'Berhasil',
    data['message'] ?? 'Password berhasil direset',
    snackPosition: SnackPosition.TOP,
  );

  Future.delayed(
    const Duration(milliseconds: 300),
    () {
      Get.offAllNamed(AppRoutes.login);
    },
  );
} else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Password gagal direset',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("RESET PASSWORD ERROR : $e");

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
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}