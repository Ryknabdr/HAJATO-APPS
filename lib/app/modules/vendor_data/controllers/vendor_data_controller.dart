import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_config.dart';

class VendorDataController extends GetxController {
  final isLoading = false.obs;
  final isSaving = false.obs;

  final vendorId = ''.obs;
  final businessName = ''.obs;
  final category = ''.obs;
  final description = ''.obs;
  final location = ''.obs;
  final phone = ''.obs;

  final ownerName = ''.obs;
  final nik = ''.obs;
  final npwp = ''.obs;

  final ktpImage = ''.obs;
  final selfieImage = ''.obs;
  final businessLicense = ''.obs;

  final status = ''.obs;
  final createdAt = ''.obs;

  final businessNameController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final ownerNameController = TextEditingController();
  final nikController = TextEditingController();
  final npwpController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchVendorData();
  }

  @override
  void onClose() {
    businessNameController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    phoneController.dispose();
    ownerNameController.dispose();
    nikController.dispose();
    npwpController.dispose();
    super.onClose();
  }

  Future<void> fetchVendorData() async {
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

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/vendor/my-data'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('VENDOR DATA STATUS: ${response.statusCode}');
      print('VENDOR DATA BODY: ${response.body}');

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = result['data'] ?? {};

        vendorId.value = data['id'] ?? '';
        businessName.value = data['business_name'] ?? '-';
        category.value = data['category'] ?? '-';
        description.value = data['description'] ?? '-';
        location.value = data['location'] ?? '-';
        phone.value = data['phone'] ?? '-';

        ownerName.value = data['owner_name'] ?? '-';
        nik.value = data['nik'] ?? '-';
        npwp.value = data['npwp'] ?? '-';

        ktpImage.value = data['ktp_image'] ?? '';
        selfieImage.value = data['selfie_image'] ?? '';
        businessLicense.value = data['business_license'] ?? '';

        status.value = data['status'] ?? 'pending';
        createdAt.value = _formatDate(data['created_at']);

        _fillEditControllers();
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Gagal mengambil data vendor',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('FETCH VENDOR DATA ERROR: $e');

      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

void _fillEditControllers() {
  businessNameController.text =
      businessName.value == '-' ? '' : businessName.value;
  categoryController.text =
      category.value == '-' ? '' : category.value;
  descriptionController.text =
      description.value == '-' ? '' : description.value;
  locationController.text =
      location.value == '-' ? '' : location.value;
  phoneController.text =
      phone.value == '-' ? '' : phone.value;
  ownerNameController.text =
      ownerName.value == '-' ? '' : ownerName.value;
  nikController.text =
      nik.value == '-' ? '' : nik.value;
  npwpController.text =
      npwp.value == '-' ? '' : npwp.value;
}

void prepareEditForm() {
  _fillEditControllers();
}

  Future<void> updateVendorData() async {
    if (businessNameController.text.trim().isEmpty ||
        categoryController.text.trim().isEmpty) {
      Get.snackbar(
        'Gagal',
        'Nama usaha dan kategori wajib diisi',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isSaving.value = true;

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

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConfig.baseUrl}/api/vendor/my-data'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['business_name'] = businessNameController.text.trim();
      request.fields['category'] = categoryController.text.trim();
      request.fields['description'] = descriptionController.text.trim();
      request.fields['location'] = locationController.text.trim();
      request.fields['phone'] = phoneController.text.trim();
      request.fields['owner_name'] = ownerNameController.text.trim();
      request.fields['nik'] = nikController.text.trim();
      request.fields['npwp'] = npwpController.text.trim();

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('UPDATE VENDOR DATA STATUS: ${response.statusCode}');
      print('UPDATE VENDOR DATA BODY: ${response.body}');

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = result['data'] ?? {};

        businessName.value = data['business_name'] ?? '-';
        category.value = data['category'] ?? '-';
        description.value = data['description'] ?? '-';
        location.value = data['location'] ?? '-';
        phone.value = data['phone'] ?? '-';

        ownerName.value = data['owner_name'] ?? '-';
        nik.value = data['nik'] ?? '-';
        npwp.value = data['npwp'] ?? '-';

        ktpImage.value = data['ktp_image'] ?? '';
        selfieImage.value = data['selfie_image'] ?? '';
        businessLicense.value = data['business_license'] ?? '';

        status.value = data['status'] ?? 'pending';

        await prefs.setString('business_name', businessName.value);
        await prefs.setString('vendor_business_name', businessName.value);
        await prefs.setString('vendor_name', businessName.value);

        await prefs.setString('name', ownerName.value);
        await prefs.setString('user_name', ownerName.value);
        await prefs.setString('owner_name', ownerName.value);
        await prefs.setString('vendor_owner_name', ownerName.value);

        _fillEditControllers();

      Get.back();

      await fetchVendorData();

      Get.snackbar(
        'Berhasil',
        'Data vendor berhasil diperbarui',
        snackPosition: SnackPosition.TOP,
      );
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Data vendor gagal diperbarui',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('UPDATE VENDOR DATA ERROR: $e');

      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isSaving.value = false;
    }
  }

  String getImageUrl(String filename) {
    if (filename.isEmpty || filename == '-') {
      return '';
    }

    if (filename.startsWith('http')) {
      return filename;
    }

    return '${ApiConfig.baseUrl}/uploads/$filename';
  }

  String getStatusText() {
    switch (status.value) {
      case 'approved':
        return 'Vendor Disetujui';
      case 'rejected':
        return 'Vendor Ditolak';
      default:
        return 'Menunggu Verifikasi';
    }
  }

  String _formatDate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return '-';
    }

    try {
      final date = DateTime.parse(value.toString()).toLocal();

      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();

      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');

      return '$day/$month/$year, $hour:$minute';
    } catch (e) {
      return value.toString();
    }
  }
}