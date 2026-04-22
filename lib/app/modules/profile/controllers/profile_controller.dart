import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final name      = 'Budi Santoso'.obs;
  final email     = 'budi@email.com'.obs;
  final phone     = '08123456789'.obs;
  final bio       = 'Flutter Developer | GetX Enthusiast'.obs;
  final avatarUrl = ''.obs;
  final isLoading = false.obs;

  // notifikasi toggle
  final notifPromo   = true.obs;
  final notifBooking = true.obs;
  final notifChat    = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      name.value  = 'Budi Santoso';
      email.value = 'budi@email.com';
      phone.value = '08123456789';
      bio.value   = 'Flutter Developer | GetX Enthusiast';
    } finally {
      isLoading.value = false;
    }
  }

  void updateProfile({
    required String newName,
    required String newPhone,
    required String newBio,
  }) {
    name.value  = newName;
    phone.value = newPhone;
    bio.value   = newBio;
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

  void logout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar',
            style: TextStyle(
                color: Color(0xFFFF6B2C), fontWeight: FontWeight.bold)),
        content: const Text('Apakah kamu yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal',
                style: TextStyle(color: Color(0xFF8A8278))),
          ),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B2C),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child:
                const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void deleteAccount() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Akun',
            style:
                TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text(
            'Akun kamu akan dihapus permanen dan tidak bisa dipulihkan.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal',
                style: TextStyle(color: Color(0xFF8A8278))),
          ),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child:
                const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String msg) {
    Get.snackbar(
      'Berhasil', msg,
      backgroundColor: const Color(0xFFFF6B2C),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}