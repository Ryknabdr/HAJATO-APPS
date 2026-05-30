import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:hajato/app/core/constants/api_config.dart';

import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> saveFCMToken(String jwtToken) async {
  try {
    final fcmToken =
        await FirebaseMessaging.instance.getToken();

    if (fcmToken == null) return;

    await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/auth/save-fcm-token',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'fcm_token': fcmToken,
      }),
    );

    print('FCM TOKEN SAVED');
  } catch (e) {
    print('SAVE FCM ERROR: $e');
  }
}

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
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
        final businessName = data['business_name'] ?? '';
        final photoUrl = data['photo_url'] ?? '';
        final prefs = await SharedPreferences.getInstance();

        await prefs.clear();

        await prefs.setString('token', token);
        await prefs.setString('name', name);
        await prefs.setString('email', email);
        await prefs.setString('phone', phone);
        await prefs.setString('role', role);
        await prefs.setString('vendor_status', vendorStatus);
        await prefs.setString('business_name', businessName);
        await prefs.setString('photo_url', photoUrl);
        await saveFCMToken(token);
        print("TOKEN : $token");
        print("ROLE : $role");
        print("VENDOR STATUS : $vendorStatus");
        print("BUSINESS NAME : $businessName");

        Get.snackbar(
          'Berhasil',
          'Login berhasil',
          snackPosition: SnackPosition.TOP,
        );

        if (role == 'admin') {
          Get.offAllNamed(AppRoutes.dashboard);
        } else if (role == 'vendor' && vendorStatus == 'approved') {
          Get.offAllNamed(AppRoutes.vendorDashboard);
        } else if (role == 'vendor_pending' || vendorStatus == 'pending') {
          Get.offAllNamed(AppRoutes.vendorDashboard);
        } else {
          Get.offAllNamed(AppRoutes.home, arguments: data);
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
  Get.toNamed(AppRoutes.forgotPassword);
}

Future<void> loginWithGoogle() async {
  isLoading.value = true;

  try {
    final googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize(
  serverClientId:
      '657219334090-jdj45qp4ek46lk5cmuke1qo5qnqf2fn0.apps.googleusercontent.com',
);

    final googleUser = await googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      Get.snackbar(
        'Google Login Gagal',
        'ID Token tidak ditemukan',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/google-login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idToken': idToken,
      }),
    );

    print("GOOGLE STATUS : ${response.statusCode}");
    print("GOOGLE BODY : ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'] ?? '';
      final name = data['name'] ?? '';
      final email = data['email'] ?? '';
      final role = data['role'] ?? '';
      final phone = data['phone'] ?? '';
      final vendorStatus = data['vendor_status'] ?? '';
      final businessName = data['business_name'] ?? '';
      final photoUrl = data['photo_url'] ?? '';
      final prefs = await SharedPreferences.getInstance();

      await prefs.clear();
      await prefs.setString('token', token);
      await prefs.setString('name', name);
      await prefs.setString('email', email);
      await prefs.setString('phone', phone);
      await prefs.setString('role', role);
      await prefs.setString('vendor_status', vendorStatus);
      await prefs.setString('business_name', businessName);
      await prefs.setString('photo_url', photoUrl);
      await saveFCMToken(token);

      Get.snackbar(
        'Berhasil',
        'Login Google berhasil',
        snackPosition: SnackPosition.TOP,
      );

      if (role == 'admin') {
        Get.offAllNamed(AppRoutes.dashboard);
      } else if (role == 'vendor' && vendorStatus == 'approved') {
        Get.offAllNamed(AppRoutes.vendorDashboard);
      } else if (role == 'vendor_pending' || vendorStatus == 'pending') {
        Get.offAllNamed(AppRoutes.vendorDashboard);
      } else {
        Get.offAllNamed(AppRoutes.home, arguments: data);
      }
    } else {
      Get.snackbar(
        'Google Login Gagal',
        data['message'] ?? 'Terjadi kesalahan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEDED),
        colorText: const Color(0xFF991F1F),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  } catch (e) {
    print("GOOGLE LOGIN ERROR : $e");

    Get.snackbar(
      'Error',
      'Tidak dapat login dengan Google',
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
