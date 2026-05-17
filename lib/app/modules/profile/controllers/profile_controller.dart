import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hajato/app/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final bio = ''.obs;
  final avatarUrl = ''.obs;
  final isLoading = false.obs;

  // notifikasi toggle
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

    // optional
    phone.value = prefs.getString('phone') ?? '08123456789';
    bio.value = prefs.getString('bio') ?? 'Pengguna HajatKu';

    print('NAME LOGIN: ${name.value}');
    print('EMAIL LOGIN: ${email.value}');

  } finally {
    isLoading.value = false;
  }
}

  void updateProfile({
    required String newName,
    required String newPhone,
    required String newBio,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // UPDATE LOCAL STORAGE
    await prefs.setString('name', newName);
    await prefs.setString('phone', newPhone);
    await prefs.setString('bio', newBio);

    name.value = newName;
    phone.value = newPhone;
    bio.value = newBio;

    Get.back();

    _showSnackbar('Profil berhasil diperbarui');
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

              // HAPUS SESSION LOGIN
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