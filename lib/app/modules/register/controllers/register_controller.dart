import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  void toggleAgreeToTerms() =>
      isAgreeToTerms.value = !isAgreeToTerms.value;

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    if (!isAgreeToTerms.value) {
      Get.snackbar(
        'Syarat & Ketentuan',
        'Anda harus menyetujui syarat & ketentuan terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFF3E0),
        colorText: const Color(0xFF8B4C00),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(AppRoutes.home, arguments: nameController.text.trim());
    } catch (e) {
      Get.snackbar(
        'Gagal Daftar',
        'Terjadi kesalahan. Silakan coba lagi.',
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

  void goToLogin() => Get.back();

  void registerWithGoogle() {
    Get.snackbar(
      'Google',
      'Daftar dengan Google belum tersedia.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void registerWithFacebook() {
    Get.snackbar(
      'Facebook',
      'Daftar dengan Facebook belum tersedia.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  String? validateName(String? val) {
    if (val == null || val.trim().isEmpty) return 'Nama tidak boleh kosong';
    if (val.trim().length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  String? validateEmail(String? val) {
    if (val == null || val.isEmpty) return 'Email tidak boleh kosong';
    if (!GetUtils.isEmail(val)) return 'Masukkan email yang valid';
    return null;
  }

  String? validatePhone(String? val) {
    if (val == null || val.isEmpty) return 'Nomor HP tidak boleh kosong';
    if (!GetUtils.isPhoneNumber(val)) return 'Masukkan nomor HP yang valid';
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Kata sandi tidak boleh kosong';
    if (val.length < 6) return 'Minimal 6 karakter';
    return null;
  }

  String? validateConfirmPassword(String? val) {
    if (val == null || val.isEmpty) return 'Konfirmasi kata sandi tidak boleh kosong';
    if (val != passwordController.text) return 'Kata sandi tidak cocok';
    return null;
  }
}