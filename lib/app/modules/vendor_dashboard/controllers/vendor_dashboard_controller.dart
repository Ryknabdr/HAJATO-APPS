import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';

class VendorDashboardController extends GetxController {
  final services = <ServicePackage>[].obs;
  final bookings = <Map<String, dynamic>>[].obs;

  final totalPendapatan = 0.obs;
  final totalBooking = 0.obs;

  final vendorStatus = ''.obs;
  final isVerified = false.obs;

  final serviceName = ''.obs;
  final serviceDescription = ''.obs;
  final servicePrice = 0.obs;
  final isEditing = false.obs;
  final editingId = ''.obs;
  final imagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadVendorStatus();
    _loadDummyData();
  }

  Future<void> _loadVendorStatus() async {
    final prefs = await SharedPreferences.getInstance();

    vendorStatus.value = prefs.getString('vendor_status') ?? '';

    isVerified.value =
        vendorStatus.value == 'approved';
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
        onConfirm: () {
          Get.back();
        },
      );

      return false;
    }

    return true;
  }

  void showPendingPopup() {
    checkVendorAccess();
  }

  void _loadDummyData() {
    services.assignAll([
      ServicePackage(
        id: 's1',
        name: 'Paket Basic',
        description: 'Layanan dasar',
        price: 1500000,
        features: ['Fitur 1', 'Fitur 2'],
      ),
      ServicePackage(
        id: 's2',
        name: 'Paket Premium',
        description: 'Layanan premium lengkap',
        price: 3500000,
        features: ['Fitur 1', 'Fitur 2', 'Fitur 3'],
      ),
    ]);

    bookings.assignAll([
      {
        'id': 'b1',
        'customer': 'Ahmad Fauzi',
        'package': 'Paket Basic',
        'date': '20 Juni 2025',
        'status': 'confirmed',
        'amount': 1500000,
      },
      {
        'id': 'b2',
        'customer': 'Siti Rahayu',
        'package': 'Paket Premium',
        'date': '05 Juli 2025',
        'status': 'pending',
        'amount': 3500000,
      },
      {
        'id': 'b3',
        'customer': 'Budi Santoso',
        'package': 'Paket Basic',
        'date': '12 Juli 2025',
        'status': 'confirmed',
        'amount': 1500000,
      },
    ]);

    totalBooking.value = bookings.length;
    totalPendapatan.value = 6500000;
  }

  void addOrUpdateService() {
    if (!checkVendorAccess()) return;

    if (serviceName.value.isEmpty ||
        servicePrice.value == 0) {
      Get.snackbar(
        'Peringatan',
        'Harap isi nama dan harga layanan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFBBF24),
      );
      return;
    }

    if (isEditing.value) {
      final idx = services.indexWhere(
        (s) => s.id == editingId.value,
      );

      if (idx != -1) {
        services[idx] = ServicePackage(
          id: editingId.value,
          name: serviceName.value,
          description: serviceDescription.value,
          price: servicePrice.value,
          features: [],
        );
      }
    } else {
      services.add(
        ServicePackage(
          id: const Uuid().v4(),
          name: serviceName.value,
          description: serviceDescription.value,
          price: servicePrice.value,
          features: [],
        ),
      );
    }

    Get.back();

    Get.snackbar(
      'Berhasil',
      'Layanan berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF34D399),
      colorText: Colors.white,
    );

    _resetForm();
  }

  void editService(ServicePackage s) {
    if (!checkVendorAccess()) return;

    isEditing.value = true;
    editingId.value = s.id;
    serviceName.value = s.name;
    serviceDescription.value = s.description;
    servicePrice.value = s.price;

    Get.toNamed(AppRoutes.manageService);
  }

  void deleteService(String id) {
    if (!checkVendorAccess()) return;

    services.removeWhere((s) => s.id == id);
  }

  void confirmBooking(String id) {
    if (!checkVendorAccess()) return;

    final index = bookings.indexWhere(
      (b) => b['id'] == id,
    );

    if (index != -1) {
      bookings[index]['status'] = 'confirmed';
      bookings.refresh();

      Get.snackbar(
        'Berhasil',
        'Pesanan berhasil dikonfirmasi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF34D399),
        colorText: Colors.white,
      );
    }
  }

  void _resetForm() {
    serviceName.value = '';
    serviceDescription.value = '';
    servicePrice.value = 0;
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