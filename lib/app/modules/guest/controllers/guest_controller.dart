import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hajato/app/core/constants/api_config.dart'; 
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import 'package:hajato/app/modules/event/controllers/event_controller.dart';

class GuestController extends GetxController {
  final guests = <GuestModel>[].obs;
  final isProcessingScan = false.obs;
  // Variabel form input di UI
  final nama = ''.obs;
  final nomorHP = ''.obs;
  final hadir = false.obs;
  final searchQuery = ''.obs;
  final filterStatus = 'Semua'.obs;
  final isLoading = false.obs; 

  String currentEventId = '';

  @override
  void onInit() {
    super.onInit();
    
    // 1. Cek ID dari argumen navigasi halaman sebelumnya
    if (Get.arguments != null && Get.arguments is String) {
      currentEventId = Get.arguments;
      print("[DEBUG HAJATO] GUEST CONTROLLER DETECTED EVENT ID: $currentEventId");
    }
    
    // 2. 🟢 FIX: Jika masuk dari menu bawah form undangan (argumen kosong), ambil ID langsung dari EventController
    if (currentEventId.isEmpty) {
      try {
        if (Get.isRegistered<EventController>()) {
          final eventCtrl = Get.find<EventController>();
          if (eventCtrl.currentEvent.value != null) {
            currentEventId = eventCtrl.currentEvent.value!.id;
            print("[DEBUG HAJATO] AUTO-TAKE ID FROM EVENT_CONTROLLER: $currentEventId");
          }
        }
      } catch (e) {
        print("[DEBUG HAJATO] GAGAL MENGAMBIL ID DARI EVENT CONTROLLER: $e");
      }
    }
  }

  void setNama(String v) => nama.value = v;
  void setNomorHP(String v) => nomorHP.value = v;

  // ── 1. AMBIL DATA TAMU (GET) ─────────────────────────────────────────────
  Future<void> fetchGuests(String eventId) async {
    currentEventId = eventId;
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/guests/$eventId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final List rawGuests = responseData['data'];
        
        guests.assignAll(rawGuests.map((g) => GuestModel(
          id: g['id'] ?? '',
          name: g['name'] ?? '',
          phone: g['phone'] ?? '',
          status: g['status'] ?? 'pending',
          hadir: g['status'] == 'confirmed' || g['status'] == 'attended',
          checkedIn: g['status'] == 'attended', 
          qrData: g['qr_code'] ?? 'HAJATO-${g['id']}',
        )).toList());
      }
    } catch (e) {
      print("[DEBUG HAJATO] GAGAL FETCH TAMU: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ── 2. LOGIKA FILTER PENCARIAN ──────────────────────────────────────────
  List<GuestModel> get filteredGuests {
    return guests.where((g) {
      final matchSearch = searchQuery.value.isEmpty ||
          g.name.toLowerCase().contains(searchQuery.value.toLowerCase());
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

  // ── 3. DAFTARKAN TAMU MANUAL (POST) ──────────────────────────────────────
  Future<void> registerGuest() async {
    if (nama.value.isEmpty || nomorHP.value.isEmpty) {
      Get.snackbar('Peringatan', 'Harap isi nama dan nomor HP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFBBF24));
      return;
    }

    if (currentEventId.isEmpty) {
      Get.snackbar('Error', 'ID Acara tidak ditemukan. Gagal mendaftarkan tamu.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      Map<String, dynamic> bodyData = {
        "name": nama.value.trim(),
        "phone": nomorHP.value.trim(),
        "status": hadir.value ? "confirmed" : "pending",
      };

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/guests/$currentEventId/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(bodyData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['status'] == 'success') {
        Get.back();
        Get.snackbar('Berhasil', 'Tamu ${nama.value} berhasil didaftarkan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF34D399),
            colorText: Colors.white);
        
        nama.value = '';
        nomorHP.value = '';
        hadir.value = false;

        fetchGuests(currentEventId);
      } else {
        Get.snackbar('Gagal', responseData['message'] ?? 'Gagal menyimpan data tamu',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("[DEBUG HAJATO] ERROR SAVE GUEST: $e");
      Get.snackbar('Error', 'Gagal terhubung ke server',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void goToQRCode(GuestModel guest) {
    Get.toNamed(AppRoutes.qrCode, arguments: guest);
  }

  // ── 4. 🟢 SELESAI PERBAIKAN: PROSES CHECK-IN SCAN QR (POST) ────────────────
  Future<void> checkIn(String qrData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/guests/checkin'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"qr_code": qrData}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        // Cari tamu di local list dan ganti statusnya biar UI rekap langsung update
        final guest = guests.firstWhereOrNull((g) => g.qrData == qrData);
        if (guest != null) {
          final index = guests.indexOf(guest);
          
          guests[index] = GuestModel(
            id: guest.id,
            name: guest.name,
            phone: guest.phone,
            status: 'attended',
            hadir: true,
            checkedIn: true,
            qrData: guest.qrData,
          );
        }
        
        // Snackbar sukses dibikin 2 detik saja biar cepet ilang dan siap scan lagi
        Get.snackbar(
          '✅ Check-in Berhasil', 
          'Selamat datang, ${responseData['data']['name']}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF34D399),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        // Jika barcode salah (404) atau ada kendala lain dari Flask
        Get.snackbar(
          '❌ Check-in Gagal', 
          responseData['message'] ?? 'QR Tidak Valid / Salah',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444), // Merah solid cerah
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar('❌ Error Konek Server', 'Gagal menyambungkan ke Flask backend.',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      // 🟢 KUNCI DIUBAH JADI 800 MILIDETIK (Gak kemaleman, gak nge-spam)
      await Future.delayed(const Duration(milliseconds: 1200));
      isProcessingScan.value = false; // Kunci dibuka kembali
    }
  }
}