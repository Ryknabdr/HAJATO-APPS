import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(AppRoutes.home, arguments: 'pengguna');
    } catch (e) {
      Get.snackbar(
        'Gagal Masuk',
        'Email atau kata sandi salah.',
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

  // Sementara pakai snackbar sampai halaman register dibuat
  void goToRegister() {
    Get.snackbar(
      'Segera Hadir',
      'Halaman daftar akun segera tersedia.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // Sementara pakai snackbar sampai halaman forgot password dibuat
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

  void loginWithFacebook() {
    Get.snackbar(
      'Facebook',
      'Login Facebook belum tersedia.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  String? validateEmail(String? val) {
    if (val == null || val.isEmpty) return 'Email tidak boleh kosong';
    if (!GetUtils.isEmail(val) && !GetUtils.isPhoneNumber(val)) {
      return 'Masukkan email atau nomor HP yang valid';
    }
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Kata sandi tidak boleh kosong';
    if (val.length < 6) return 'Minimal 6 karakter';
    return null;
  }
}