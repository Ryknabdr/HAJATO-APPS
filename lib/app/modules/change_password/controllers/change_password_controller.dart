import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_config.dart';

class ChangePasswordController extends GetxController {
  final isLoading = false.obs;

  final role = 'user'.obs;
  final newPasswordText = ''.obs;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isOldPasswordHidden = true.obs;
  final isNewPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  int get minPasswordLength {
    if (role.value == 'vendor' || role.value == 'vendor_pending') {
      return 8;
    }

    return 6;
  }

  String get passwordRuleText {
    return 'Password baru minimal $minPasswordLength karakter';
  }

  bool get shouldShowPasswordWarning {
  return newPasswordText.value.isNotEmpty &&
      newPasswordText.value.length < minPasswordLength;
}

String get passwordWarningText {
  return 'Password baru minimal $minPasswordLength karakter';
}

void onNewPasswordChanged(String value) {
  newPasswordText.value = value;
}

  @override
  void onInit() {
    super.onInit();
    loadUserRole();
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    role.value = prefs.getString('role') ?? 'user';

    print('CHANGE PASSWORD ROLE: ${role.value}');
    print('CHANGE PASSWORD MIN LENGTH: $minPasswordLength');
  }

  void toggleOldPasswordVisibility() {
    isOldPasswordHidden.value = !isOldPasswordHidden.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> changePassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Semua field password wajib diisi',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    await loadUserRole();

    if (newPassword.length < minPasswordLength) {
      Get.snackbar(
        'Gagal',
        'Password baru minimal $minPasswordLength karakter',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Gagal',
        'Konfirmasi password baru tidak sama',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (oldPassword == newPassword) {
      Get.snackbar(
        'Gagal',
        'Password baru tidak boleh sama dengan password lama',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Gagal',
          'Token tidak ditemukan. Silakan login ulang.',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      print('CHANGE PASSWORD STATUS: ${response.statusCode}');
      print('CHANGE PASSWORD BODY: ${response.body}');

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        Get.back();

        Get.snackbar(
          'Berhasil',
          result['message'] ?? 'Password berhasil diubah',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Password gagal diubah',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('CHANGE PASSWORD ERROR: $e');

      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}