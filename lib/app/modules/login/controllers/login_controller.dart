import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  static const String baseUrl =
      'https://unedacious-aerogenically-sammie.ngrok-free.dev/api/auth';

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      print("STATUS : ${response.statusCode}");
      print("BODY : ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'] ?? '';
        final name = data['name'] ?? '';
        final email = data['email'] ?? '';
        final role = data['role'] ?? '';
        final phone = data['phone'] ?? '';
        final vendorStatus = data['vendor_status'] ?? '';

        final prefs = await SharedPreferences.getInstance();

        await prefs.clear();
        await prefs.setString('token', token);
        await prefs.setString('name', name);
        await prefs.setString('email', email);
        await prefs.setString('phone', phone);
        await prefs.setString('role', role);
        await prefs.setString('vendor_status', vendorStatus);

        print("TOKEN : $token");
        print("ROLE : $role");
        print("VENDOR STATUS : $vendorStatus");

        Get.snackbar(
          'Berhasil',
          'Login berhasil',
          snackPosition: SnackPosition.BOTTOM,
        );

        if (role == 'admin') {
          Get.offAllNamed(AppRoutes.dashboard);
        } else if (role == 'vendor' && vendorStatus == 'approved') {
          Get.offAllNamed(AppRoutes.vendorDashboard);
        } else if (role == 'vendor_pending' || vendorStatus == 'pending') {
          Get.offAllNamed(AppRoutes.vendorDashboard);
        } else {
          Get.offAllNamed(
            AppRoutes.home,
            arguments: data,
          );
        }
      } else {
        Get.snackbar(
          'Login Gagal',
          data['message'] ?? 'Email atau password salah',
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

  void goToRegister() {
  Get.offNamed(AppRoutes.register);
}

  void goToForgotPassword() {
    Get.snackbar(
      'Segera Hadir',
      'Fitur lupa kata sandi segera tersedia.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void loginWithGoogle() {
    Get.snackbar(
      'Google',
      'Login Google belum tersedia.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void loginWithFaceId() {
    Get.snackbar(
      'Segera Hadir',
      'Fitur Face ID sedang dalam pengembangan.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
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

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }

    if (val.length < 6) {
      return 'Minimal 6 karakter';
    }

    return null;
  }
}