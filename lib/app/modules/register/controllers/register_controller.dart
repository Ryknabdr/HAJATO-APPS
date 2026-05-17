import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final isAgreeToTerms = false.obs;

  // GANTI SESUAI IPV4 LAPTOP
  // Samakan dengan baseUrl yang dipakai di login/auth_service
  static const String baseUrl = 'https://unedacious-aerogenically-sammie.ngrok-free.dev/api/auth';

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value =
        !isConfirmPasswordVisible.value;
  }

  void toggleAgreeToTerms() {
    isAgreeToTerms.value = !isAgreeToTerms.value;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    if (!isAgreeToTerms.value) {
      Get.snackbar(
        'Peringatan',
        'Setujui syarat & ketentuan terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'password': passwordController.text.trim(),
          'role': 'user',
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          'Register berhasil',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.snackbar(
          'Register Gagal',
          data['message'] ?? 'Terjadi kesalahan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFFEDED),
          colorText: const Color(0xFF991F1F),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      print(e);

      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEDED),
        colorText: const Color(0xFF991F1F),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.back();
  }

  void registerWithGoogle() {
    Get.snackbar(
      'Google',
      'Daftar dengan Google belum tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void registerWithFacebook() {
    Get.snackbar(
      'Facebook',
      'Daftar dengan Facebook belum tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String? validateName(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (val.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }

    return null;
  }

  String? validateEmail(String? val) {
    if (val == null || val.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    if (!GetUtils.isEmail(val)) {
      return 'Masukkan email valid';
    }

    return null;
  }

  String? validatePhone(String? val) {
    if (val == null || val.isEmpty) {
      return 'Nomor HP tidak boleh kosong';
    }

    if (!GetUtils.isPhoneNumber(val)) {
      return 'Masukkan nomor HP valid';
    }

    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }

    if (val.length < 6) {
      return 'Minimal 6 karakter';
    }

    return null;
  }

  String? validateConfirmPassword(String? val) {
    if (val == null || val.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (val != passwordController.text) {
      return 'Password tidak cocok';
    }

    return null;
  }
}