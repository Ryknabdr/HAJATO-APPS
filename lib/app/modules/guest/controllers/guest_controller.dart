import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/dummy_data.dart';
import '../../../routes/app_routes.dart';

class GuestController extends GetxController {
  final guests = <GuestModel>[].obs;
  final nama = ''.obs;
  final nomorHP = ''.obs;
  final hadir = false.obs;
  final searchQuery = ''.obs;
  final filterStatus = 'Semua'.obs;

  @override
  void onInit() {
    super.onInit();
    guests.assignAll(DummyData.sampleGuests);
  }

  List<GuestModel> get filteredGuests {
    return guests.where((g) {
      final matchSearch = searchQuery.value.isEmpty ||
          g.nama.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchFilter = filterStatus.value == 'Semua' ||
          (filterStatus.value == 'Hadir' && g.hadir) ||
          (filterStatus.value == 'Tidak Hadir' && !g.hadir) ||
          (filterStatus.value == 'Check-in' && g.checkedIn);
      return matchSearch && matchFilter;
    }).toList();
  }

  int get totalGuests => guests.length;
  int get hadirCount => guests.where((g) => g.hadir).length;
  int get checkedInCount => guests.where((g) => g.checkedIn).length;

  void registerGuest() {
    if (nama.value.isEmpty || nomorHP.value.isEmpty) {
      Get.snackbar('Peringatan', 'Harap isi nama dan nomor HP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFBBF24));
      return;
    }
    final id = const Uuid().v4();
    guests.add(GuestModel(
      id: id,
      nama: nama.value,
      nomorHP: nomorHP.value,
      hadir: hadir.value,
      qrData: 'HAJATO-$id-${nama.value}',
    ));
    Get.back();
    Get.snackbar('Berhasil', 'Tamu ${nama.value} berhasil didaftarkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF34D399),
        colorText: Colors.white);
    nama.value = '';
    nomorHP.value = '';
    hadir.value = false;
  }

  void goToQRCode(GuestModel guest) {
    Get.toNamed(AppRoutes.qrCode, arguments: guest);
  }

  void checkIn(String qrData) {
    final guest = guests.firstWhereOrNull((g) => g.qrData == qrData);
    if (guest != null) {
      final index = guests.indexOf(guest);
      guests[index] = GuestModel(
        id: guest.id,
        nama: guest.nama,
        nomorHP: guest.nomorHP,
        hadir: true,
        checkedIn: true,
        qrData: guest.qrData,
      );
      Get.snackbar('✅ Check-in Berhasil', 'Selamat datang, ${guest.nama}!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF34D399),
          colorText: Colors.white);
    } else {
      Get.snackbar('❌ QR Tidak Valid', 'Tamu tidak ditemukan dalam daftar.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF87171),
          colorText: Colors.white);
    }
  }
}
