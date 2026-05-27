import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hajato/app/core/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hajato/app/core/constants/api_config.dart';

class ProfileController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final bio = ''.obs;
  final avatarUrl = ''.obs;
  final isLoading = false.obs;

  final notifPromo = true.obs;
  final notifBooking = true.obs;
  final notifChat = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();

      name.value = prefs.getString('name') ?? 'Pengguna';
      email.value = prefs.getString('email') ?? '-';
      phone.value = prefs.getString('phone') ?? '';
      bio.value = prefs.getString('bio') ?? '';
      avatarUrl.value = prefs.getString('photo_url') ?? '';

      print('NAME LOGIN: ${name.value}');
      print('EMAIL LOGIN: ${email.value}');
      print('AVATAR URL: ${avatarUrl.value}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String newName,
    required String newPhone,
    required String newBio,
  }) async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error',
          'Token tidak ditemukan, silakan login ulang',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': newName,
          'phone': newPhone,
          'bio': newBio,
        }),
      );

      print('UPDATE PROFILE STATUS: ${response.statusCode}');
      print('UPDATE PROFILE BODY: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final profileData = data['data'] ?? {};

        final updatedName = profileData['name'] ?? newName;
        final updatedPhone = profileData['phone'] ?? newPhone;
        final updatedBio = profileData['bio'] ?? newBio;

        await prefs.setString('name', updatedName);
        await prefs.setString('phone', updatedPhone);
        await prefs.setString('bio', updatedBio);

        name.value = updatedName;
        phone.value = updatedPhone;
        bio.value = updatedBio;

        Get.back();

        _showSnackbar('Profil berhasil diperbarui');
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Profil gagal diperbarui',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('UPDATE PROFILE ERROR: $e');

      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    Get.back();
    _showSnackbar('Kata sandi berhasil diubah');
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Keluar',
          style: TextStyle(
            color: Color(0xFFFF6B2C),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Apakah kamu yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xFF8A8278)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await prefs.clear();
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B2C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void deleteAccount() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Hapus Akun',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Akun kamu akan dihapus permanen dan tidak bisa dipulihkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xFF8A8278)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String msg) {
    Get.snackbar(
      'Berhasil',
      msg,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}