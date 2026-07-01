import 'dart:convert';
import 'dart:io'; // Diperlukan untuk handle data File gambar

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hajato/app/core/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Jangan lupa tambahkan image_picker di pubspec.yaml
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hajato/app/routes/app_routes.dart';
import 'package:hajato/app/core/constants/api_config.dart';

// ── 🟢 IMPORT CONTROLLER DASHBOARD BIAR BISA DI-RESET ──
import 'package:hajato/app/modules/dashboard/controllers/dashboard_controller.dart'; // Sesuaikan dengan folder path dashboard lo bos

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

  /// Fungsi baru untuk memilih gambar dari Galeri HP pengguna
  Future<File?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80, // Kompres sedikit kualitas gambar agar tidak terlalu besar saat di-upload
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('PICK IMAGE ERROR: $e');
    }
    return null;
  }

  /// Fungsi updateProfile yang telah dimodifikasi menggunakan http.MultipartRequest
  Future<void> updateProfile({
    required String newName,
    required String newPhone,
    required String newBio,
    File? imageFile, // Parameter opsional untuk menampung file gambar dari View
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

      // Mengubah request menjadi MultipartRequest karena ada pengiriman file
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/update-profile');
      final request = http.MultipartRequest('PUT', uri);

      // 1. Tambahkan Header Authentication
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // 2. Tambahkan Data Text Form Fields
      request.fields['name'] = newName;
      request.fields['phone'] = newPhone;
      request.fields['bio'] = newBio;

      // 3. Tambahkan File Gambar (jika pengguna memilih foto baru)
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'avatar', // Key field nama parameter ini harus sinkron dengan backend kamu
            imageFile.path,
          ),
        );
        print('Menambahkan file gambar ke request: ${imageFile.path}');
      }

      // 4. Mengirimkan Multipart request ke Server
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('UPDATE PROFILE STATUS: ${response.statusCode}');
      print('UPDATE PROFILE BODY: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final profileData = data['data'] ?? {};

        final updatedName = profileData['name'] ?? newName;
        final updatedPhone = profileData['phone'] ?? newPhone;
        final updatedBio = profileData['bio'] ?? newBio;
        // Ambil URL foto profil baru yang dihasilkan dari backend jika tersedia
        final updatedAvatar = profileData['photo_url'] ?? avatarUrl.value;

        // Simpan data terbaru ke Local SharedPreferences
        await prefs.setString('name', updatedName);
        await prefs.setString('phone', updatedPhone);
        await prefs.setString('bio', updatedBio);
        await prefs.setString('photo_url', updatedAvatar);

        // Update nilai Rx data agar tampilan UI otomatis berubah seketika
        name.value = updatedName;
        phone.value = updatedPhone;
        bio.value = updatedBio;
        avatarUrl.value = updatedAvatar;

        Get.back(); // Kembali ke halaman profil

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
              isLoading.value = true; // Set loading jadi true
              final token = prefs.getString('token');

              try {
                if (token != null && token.isNotEmpty) {
                  await http.post(
                    Uri.parse('${ApiConfig.baseUrl}/api/auth/logout'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $token',
                    },
                  );
                }
              } catch (e) {
                print('LOGOUT ERROR: $e');
              } finally {
                // ── 🟢 FIX KUNCI: AMBIL DAN AMANKAN DULU ID ACARANYA SEBELUM DI-RESET ──
                String? savedEventId = prefs.getString('selected_event_id');

                if (Get.isRegistered<DashboardController>()) {
                  // Kita hancurkan instancenya saja tanpa memanggil clearDashboardState() yang merusak data memori
                  Get.delete<DashboardController>(force: true); 
                }
                
                print("[DEBUG HAJATO] DATA LOGIN BERHASIL DI-CLEAR! TAPI EVENT ID AMAN. 🧹");

                // Hapus data login secara manual satu per satu
                await prefs.remove('token');
                await prefs.remove('name');
                await prefs.remove('email');
                await prefs.remove('phone');
                await prefs.remove('bio');
                await prefs.remove('photo_url');

                // ── 🟢 KUNCI UTAMA: TULIS ULANG ID ACARA BIAR TETEP NYANGKUT DI HP ──
                if (savedEventId != null && savedEventId.isNotEmpty) {
                  await prefs.setString('selected_event_id', savedEventId);
                  print("[DEBUG HAJATO] SUKSES MENAHAN EVENT ID: $savedEventId");
                }

                isLoading.value = false; // Set loading jadi false
                Get.back(); // Tutup dialog
                Get.offAllNamed(AppRoutes.login); // Pindah ke halaman login
              }
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