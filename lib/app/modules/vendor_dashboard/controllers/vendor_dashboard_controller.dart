import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/api_config.dart';

class VendorDashboardController extends GetxController {
  final services = <ServicePackage>[].obs;
  final bookings = <BookingModel>[].obs;

  final totalPendapatan = 0.obs;
  final totalBooking = 0.obs;

  final vendorStatus = ''.obs;
  final businessName = ''.obs;
  final isVerified = false.obs;

  final serviceName = ''.obs;
  final serviceDescription = ''.obs;
  final servicePrice = 0.obs;

  final serviceCapacity = ''.obs;
  final serviceDuration = ''.obs;

  final isEditing = false.obs;
  final editingId = ''.obs;

  final imagePath = ''.obs;

  final serviceCategory = 'Fotografer'.obs;

  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadVendorStatus();
    fetchMyServices();
    fetchVendorBookings();
  }

  @override
  void onReady() {
  super.onReady();
  fetchVendorBookings();
}

  Future<void> _loadVendorStatus() async {
    final prefs = await SharedPreferences.getInstance();

    vendorStatus.value = prefs.getString('vendor_status') ?? '';
    businessName.value = prefs.getString('business_name') ?? 'Vendor';

    isVerified.value = vendorStatus.value == 'approved';
  }

  bool checkVendorAccess() {
    if (!isVerified.value) {
      Get.defaultDialog(
        title: 'Menunggu Verifikasi',
        middleText:
            'Akun vendor Anda sedang menunggu verifikasi dari admin. Fitur ini belum bisa digunakan.',
        textConfirm: 'Mengerti',
        confirmTextColor: Colors.white,
        buttonColor: const Color(0xFF0F766E),
        onConfirm: () => Get.back(),
      );

      return false;
    }

    return true;
  }

  void showPendingPopup() {
    checkVendorAccess();
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      imagePath.value = image.path;
    }
  }

  Future<void> fetchMyServices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/vendor/my-services'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List list = data['data'] ?? [];

        services.assignAll(
          list.map((e) {
            return ServicePackage(
              id: e['id'],
              name: e['name'],
              category: e['category'] ?? '',
              description: e['description'],
              price: e['price'],
              capacity: e['capacity'] ?? '',
              duration: e['duration'] ?? '',
              features: List<String>.from(e['features'] ?? []),
              image: e['image'] ?? '',
            );
          }).toList(),
        );
      }
    } catch (e) {
      print('FETCH SERVICES ERROR: $e');
    }
  }

  Future<void> fetchVendorBookings() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/booking/vendor-bookings'),

        headers: {'Authorization': 'Bearer $token'},
      );

      print('VENDOR DASHBOARD BOOKINGS: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        bookings.assignAll(
          List<BookingModel>.from(data.map((e) => BookingModel.fromJson(e))),
        );

        totalBooking.value = bookings.length;

        totalPendapatan.value = bookings.fold(
          0,
          (sum, item) => sum + item.totalPrice,
        );
      }
    } catch (e) {
      print('FETCH BOOKINGS ERROR: $e');
    }
  }

  Future<void> addOrUpdateService() async {
    if (!checkVendorAccess()) return;

    if (serviceName.value.isEmpty ||
        serviceDescription.value.isEmpty ||
        servicePrice.value == 0) {
      Get.snackbar(
        'Peringatan',
        'Harap isi nama, deskripsi, dan harga layanan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFBBF24),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final request = http.MultipartRequest(
        isEditing.value ? 'PUT' : 'POST',
        Uri.parse(
          isEditing.value
              ? '${ApiConfig.baseUrl}/api/vendor/services/${editingId.value}'
              : '${ApiConfig.baseUrl}/api/vendor/services',
        ),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = serviceName.value;
      request.fields['category'] = serviceCategory.value;
      request.fields['description'] = serviceDescription.value;
      request.fields['price'] = servicePrice.value.toString();
      request.fields['capacity'] = serviceCapacity.value;
      request.fields['duration'] = serviceDuration.value;

      if (imagePath.value.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imagePath.value),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchMyServices();

        Get.back();

        Get.snackbar(
          'Berhasil',
          isEditing.value
              ? 'Layanan berhasil diupdate'
              : 'Layanan berhasil ditambahkan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF34D399),
          colorText: Colors.white,
        );

        _resetForm();
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Layanan gagal disimpan',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('SAVE SERVICE ERROR: $e');

      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void editService(ServicePackage s) {
    if (!checkVendorAccess()) return;

    serviceName.value = s.name;
    serviceCategory.value = 'Wedding';
    serviceDescription.value = s.description;
    servicePrice.value = s.price;

    editingId.value = s.id;
    isEditing.value = true;
    imagePath.value = '';

    Get.toNamed(AppRoutes.manageService);
  }

  Future<void> deleteService(String id) async {
    if (!checkVendorAccess()) return;

    final confirm = await Get.dialog(
      AlertDialog(
        title: const Text('Hapus Layanan'),
        content: const Text('Yakin ingin menghapus layanan ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/vendor/services/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await fetchMyServices();

        Get.snackbar(
          'Berhasil',
          'Layanan berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF34D399),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Gagal menghapus layanan',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('DELETE SERVICE ERROR: $e');

      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void confirmBooking(String id) {
    if (!checkVendorAccess()) return;
  }

  void _resetForm() {
    serviceName.value = '';
    serviceCategory.value = 'Fotografer';
    serviceDescription.value = '';
    servicePrice.value = 0;
    imagePath.value = '';
    isEditing.value = false;
    editingId.value = '';
  }

  void goToNewService() {
    if (!checkVendorAccess()) return;

    _resetForm();
    Get.toNamed(AppRoutes.manageService);
  }

  void goToVendorChat() {
    if (!checkVendorAccess()) return;

    Get.toNamed(AppRoutes.vendorChat);
  }

  void goToSchedule() {
    if (!checkVendorAccess()) return;
  }

  void goToStatistic() {
    if (!checkVendorAccess()) return;
  }
}
