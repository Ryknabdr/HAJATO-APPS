import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hajato/app/core/constants/api_config.dart';
import 'package:hajato/app/modules/auth/views/face_enrollment_view.dart';

import '../../../routes/app_routes.dart';

class VendorRegistrationController extends GetxController {
  // =========================
  // STEP
  // =========================

  final currentStep = 0.obs;
  final totalSteps = 4;

  final isLoading = false.obs;

  // =========================
  // REGISTER MODE
  // direct  = daftar vendor baru
  // upgrade = user upgrade jadi vendor
  // =========================

  final registerMode = 'direct'.obs;

  // =========================
  // FORM KEYS
  // =========================

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  // =========================
  // TEXT CONTROLLERS
  // =========================

  final businessNameController = TextEditingController();
  final businessDescController = TextEditingController();
  final businessLocationController = TextEditingController();
  final businessPhoneController = TextEditingController();

  final ownerNameController = TextEditingController();
  final ownerNikController = TextEditingController();
  final npwpController = TextEditingController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // =========================
  // CATEGORY
  // =========================

  final selectedCategory = ''.obs;

  final categories = [
    'Fotografi',
    'Dekorasi',
    'Catering',
    'Musik',
    'Makeup',
    'Wedding Organizer',
    'MC',
    'Venue',
    'Sound System',
  ];

  // =========================
  // PASSWORD
  // =========================

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // =========================
  // FILES
  // =========================

  final ktpImageFile = Rx<File?>(null);
  final selfieImageFile = Rx<File?>(null);
  final businessLicenseFile = Rx<File?>(null);

  // FOTO WAJAH VENDOR
  final faceImages = <File>[].obs;

  final isPickingKtp = false.obs;
  final isPickingSelfie = false.obs;
  final isPickingLicense = false.obs;

  final ktpError = ''.obs;
  final selfieError = ''.obs;

  final ImagePicker picker = ImagePicker();

  // =========================
  // INIT
  // =========================

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args != null && args is Map && args['mode'] != null) {
      registerMode.value = args['mode'];
    }
  }

  @override
  void onClose() {
    businessNameController.dispose();
    businessDescController.dispose();
    businessLocationController.dispose();
    businessPhoneController.dispose();

    ownerNameController.dispose();
    ownerNikController.dispose();
    npwpController.dispose();

    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }

  // =========================
  // TITLE
  // =========================

  String get stepTitle {
    switch (currentStep.value) {
      case 0:
        return 'Informasi Bisnis';
      case 1:
        return 'Verifikasi Identitas';
      case 2:
        return 'Dokumen Pendukung';
      case 3:
        return 'Review Pendaftaran';
      default:
        return '';
    }
  }

  String get stepSubtitle {
    switch (currentStep.value) {
      case 0:
        return 'Lengkapi informasi bisnis Anda';
      case 1:
        return 'Verifikasi identitas pemilik';
      case 2:
        return 'Upload dokumen tambahan';
      case 3:
        return 'Pastikan semua data benar';
      default:
        return '';
    }
  }

  // =========================
  // STEP NAVIGATION
  // =========================

  void nextStep() {
    if (currentStep.value == 0) {
      if (!(formKey1.currentState?.validate() ?? false)) {
        return;
      }

      if (selectedCategory.value.isEmpty) {
        Get.snackbar(
          'Kategori Belum Dipilih',
          'Silakan pilih kategori bisnis terlebih dahulu',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    if (currentStep.value == 1) {
      if (!(formKey2.currentState?.validate() ?? false)) {
        return;
      }
    }

    if (currentStep.value == 2) {
      if (!(formKey3.currentState?.validate() ?? false)) {
        return;
      }
    }

    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // =========================
  // IMAGE PICKER DOKUMEN
  // =========================

  Future<void> pickKtpImage() async {
    try {
      isPickingKtp.value = true;

      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (picked != null) {
        ktpImageFile.value = File(picked.path);
        ktpError.value = '';
      }
    } finally {
      isPickingKtp.value = false;
    }
  }

  Future<void> pickSelfieImage() async {
    try {
      isPickingSelfie.value = true;

      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (picked != null) {
        selfieImageFile.value = File(picked.path);
        selfieError.value = '';
      }
    } finally {
      isPickingSelfie.value = false;
    }
  }

  Future<void> pickBusinessLicense() async {
    try {
      isPickingLicense.value = true;

      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (picked != null) {
        businessLicenseFile.value = File(picked.path);
      }
    } finally {
      isPickingLicense.value = false;
    }
  }

  // =========================
  // FACE ENROLLMENT VENDOR
  // =========================

  Future<void> captureFaceImages() async {
    final result = await Get.to<List<File>>(
      () => const FaceEnrollmentView(),
    );

    if (result == null) {
      return;
    }

    if (result.length < 3) {
      Get.snackbar(
        'Belum Lengkap',
        'Silakan ambil 3 foto wajah terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    faceImages.assignAll(result);

    Get.snackbar(
      'Berhasil',
      '3 foto wajah vendor berhasil disimpan sementara',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // =========================
  // VALIDATORS
  // =========================

  String? validateBusinessName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama bisnis wajib diisi';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Deskripsi wajib diisi';
    }
    return null;
  }

  String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Lokasi wajib diisi';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor HP wajib diisi';
    }
    return null;
  }

  String? validateOwnerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi';
    }
    return null;
  }

  String? validateNik(String? value) {
    if (value == null || value.trim().length != 16) {
      return 'NIK harus 16 digit';
    }
    return null;
  }

  String? validateNpwp(String? value) {
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }

    if (!GetUtils.isEmail(value.trim())) {
      return 'Masukkan email valid';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Password tidak sama';
    }
    return null;
  }

  // =========================
  // SUBMIT
  // =========================

  Future<void> submit() async {
    final bool isUpgradeVendor = registerMode.value == 'upgrade';

    if (!isUpgradeVendor && faceImages.length < 3) {
      Get.snackbar(
        'Wajah Belum Didaftarkan',
        'Silakan daftarkan wajah vendor terlebih dahulu',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFFEDED),
        colorText: const Color(0xFF991F1F),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final uri = Uri.parse(
        isUpgradeVendor
            ? '${ApiConfig.baseUrl}/api/vendor/register-vendor'
            : '${ApiConfig.baseUrl}/api/auth/register-vendor-with-face',
      );

      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      // =========================
      // AUTH HEADER UNTUK UPGRADE
      // =========================

      if (isUpgradeVendor && token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // =========================
      // FIELDS USER
      // =========================

      request.fields['name'] = ownerNameController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['password'] = passwordController.text.trim();

      // =========================
      // FIELDS VENDOR
      // =========================

      request.fields['business_name'] = businessNameController.text.trim();
      request.fields['category'] = selectedCategory.value;
      request.fields['description'] = businessDescController.text.trim();
      request.fields['location'] = businessLocationController.text.trim();
      request.fields['phone'] = businessPhoneController.text.trim();

      request.fields['owner_name'] = ownerNameController.text.trim();
      request.fields['nik'] = ownerNikController.text.trim();
      request.fields['npwp'] = npwpController.text.trim();

      // =========================
      // FILE DOKUMEN
      // =========================

      if (ktpImageFile.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'ktp_image',
            ktpImageFile.value!.path,
          ),
        );
      }

      if (selfieImageFile.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'selfie_image',
            selfieImageFile.value!.path,
          ),
        );
      }

      if (businessLicenseFile.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'business_license',
            businessLicenseFile.value!.path,
          ),
        );
      }

      // =========================
      // FILE WAJAH VENDOR
      // Hanya untuk daftar vendor baru
      // =========================

      if (!isUpgradeVendor) {
        for (int i = 0; i < faceImages.length; i++) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'face_image_${i + 1}',
              faceImages[i].path,
            ),
          );
        }

        request.fields['pose_type_1'] = 'normal';
        request.fields['pose_type_2'] = 'smile';
        request.fields['pose_type_3'] = 'side';
      }

      // =========================
      // SEND
      // =========================

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      print('REGISTER VENDOR STATUS : ${response.statusCode}');
      print('REGISTER VENDOR BODY : ${response.body}');
      print('REGISTER MODE : ${registerMode.value}');
      print('IS UPGRADE VENDOR : $isUpgradeVendor');
      print('EMAIL VENDOR : ${emailController.text.trim()}');

      final data = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};

      // =========================
      // SUCCESS
      // =========================

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          data['message'] ?? 'Pendaftaran vendor berhasil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );

        if (isUpgradeVendor) {
          Get.offNamed('/vendor-registration-status');
        } else {
          await Future.delayed(const Duration(milliseconds: 500));

          Get.toNamed(
            AppRoutes.verifyOtp,
            arguments: {
              'email': emailController.text.trim(),
              'purpose': 'register',
            },
          );
        }
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Pendaftaran vendor gagal',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFFEDED),
          colorText: const Color(0xFF991F1F),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      print('REGISTER VENDOR ERROR : $e');

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
}