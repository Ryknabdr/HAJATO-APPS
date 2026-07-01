import 'dart:convert';
import '../../../services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hajato/app/core/constants/api_config.dart';
import '../../../routes/app_routes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
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
      final result = await AuthService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        role: 'user',
      );

      final statusCode = result['statusCode'];
      final data = result['data'];

      if (statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          data['message'] ?? 'Register berhasil. Kode OTP telah dikirim ke email',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(seconds: 1));

        Get.toNamed(
          AppRoutes.verifyOtp,
          arguments: {
            'email': emailController.text.trim(),
            'purpose': 'register',
          },
        );
      } else {
        Get.snackbar(
          'Register Gagal',
          data['message'] ?? 'Terjadi kesalahan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFFFEDED),
          colorText: const Color(0xFF991F1F),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print("REGISTER CONTROLLER ERROR : $e");

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

  // ─── 🟢 FIX NAMA FUNGSI SINKRON DENGAN REGISTER_VIEW.DART ───
  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: '657219334090-jdj45qp4ek46lk5cmuke1qo5qnqf2fn0.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        Get.snackbar(
          'Google Register Gagal',
          'ID Token tidak ditemukan',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/google-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      print("GOOGLE REGISTER STATUS : ${response.statusCode}");
      print("GOOGLE REGISTER BODY : ${response.body}");

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

        Get.snackbar(
          'Berhasil',
          'Register Google berhasil',
          snackPosition: SnackPosition.TOP,
        );

        Get.offAllNamed(AppRoutes.home, arguments: data);
      } else {
        Get.snackbar(
          'Google Register Gagal',
          data['message'] ?? 'Terjadi kesalahan',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("GOOGLE REGISTER ERROR : $e");
      Get.snackbar(
        'Error',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ─── 🟢 FIX UTAMA FACE ID BADGE: Menyediakan fungsi pasangannya di UI ───
  void loginWithFaceId() {
    Get.snackbar(
      'Informasi',
      'Fitur pendaftaran akun menggunakan Face ID sedang dalam tahap pengembangan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade50,
      colorText: Colors.blue.shade900,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
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