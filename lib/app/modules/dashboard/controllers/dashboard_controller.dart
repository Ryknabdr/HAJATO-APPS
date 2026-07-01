import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_config.dart';

// 🟢 MODEL UNTUK VENDOR DINAMIS
class VendorModel {
  final String name;
  final String cat;
  final String status;
  final String icon;
  VendorModel({required this.name, required this.cat, required this.status, required this.icon});
}

// 🟢 MODEL UNTUK AKTIVITAS DINAMIS
class ActivityModel {
  final String text;
  final String time;
  ActivityModel({required this.text, required this.time});
}

class DashboardController extends GetxController {
  final isLoading = false.obs;
  
  // Variabel data statistik dashboard
  final totalTamu = 0.obs;
  final tamuHadir = 0.obs;
  final tamuSudahCheckIn = 0.obs;
  final totalVendor = 0.obs;
  final totalBooking = 0.obs;
  
  // Menampung nama acara aktif dinamis dari server
  final eventName = ''.obs;

  // Data grafik 7 hari
  final weeklyData = <double>[0, 0, 0, 0, 0, 0, 0].obs;
  
  // 🟢 VARIABEL REAKTIF UNTUK VENDOR DAN AKTIVITAS
  final vendorList = <VendorModel>[].obs;
  final recentActivities = <ActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData(); 
  }

  // ── FUNGSI RESET STATE (Penting saat Logout / Ganti Akun) ──
  void clearDashboardState() {
    totalTamu.value = 0;
    tamuHadir.value = 0;
    tamuSudahCheckIn.value = 0;
    totalVendor.value = 0;
    totalBooking.value = 0;
    eventName.value = '';
    weeklyData.value = [0, 0, 0, 0, 0, 0, 0];
    vendorList.clear();
    recentActivities.clear();
    print("[DEBUG HAJATO] STATE DASHBOARD BERHASIL DI-RESET KE KOSONG! 🧹");
  }

  // ── FUNGSI UTAMA: TEMBAK API REAL-TIME KE FLASK BACKEND ──
  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      print("[DEBUG HAJATO] MEMULAI FETCH DATA DASHBOARD... 🚀");
      
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      // 1. Ambil ID Acara dari arguments navigasi GetX
      String currentEventId = Get.arguments?['id'] ?? ''; 
      
      // 2. Jika di arguments kosong, ambil dari SharedPreferences
      if (currentEventId.isEmpty) {
        currentEventId = prefs.getString('selected_event_id') ?? '';
      }

      print("[DEBUG HAJATO] MENGIRIM EVENT ID: $currentEventId");

      // JIKA EVENT ID TETAP KOSONG, JANGAN TERUSKAN HIT KE API GLOBAL
      if (currentEventId.isEmpty) {
        print("[DEBUG HAJATO] CANCEL FETCH: Event ID tidak ditemukan di SharedPreferences maupun Arguments.");
        clearDashboardState();
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/dashboard/stats?event_id=$currentEventId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("[DEBUG HAJATO] RESPONSE STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];

        // Sinkronisasi data utama ke UI
        eventName.value = data['event_name'] ?? 'Pernikahan Aktif';
        totalTamu.value = data['total_guest'] ?? 0;
        tamuHadir.value = data['tamu_hadir'] ?? 0;
        tamuSudahCheckIn.value = data['tamu_checkin'] ?? 0;
        totalVendor.value = data['total_vendor'] ?? 0;
        totalBooking.value = data['total_booking'] ?? 0;

        // Map data grafik mingguan
        if (data['weekly_data'] != null) {
          List<dynamic> weekly = data['weekly_data'];
          weeklyData.value = weekly.map((v) => double.parse(v.toString())).toList();
        }

        // Map data vendor
        if (data['vendors'] != null) {
          List<dynamic> vends = data['vendors'];
          vendorList.value = vends.map((v) => VendorModel(
            name: v['name'] ?? '',
            cat: v['cat'] ?? '',
            status: v['status'] ?? 'pending',
            icon: v['icon'] ?? 'store'
          )).toList();
        }

        // Map data aktivitas terbaru
        if (data['recent_activities'] != null) {
          List<dynamic> acts = data['recent_activities'];
          recentActivities.value = acts.map((a) => ActivityModel(
            text: a['text'] ?? '',
            time: a['time'] ?? ''
          )).toList();
        }
        print("[DEBUG HAJATO] FETCH DASHBOARD REAL-TIME SUKSES! 🎉");
      } else {
        print("[DEBUG HAJATO] Dashboard API bermasalah: ${response.statusCode}");
      }
    } catch (e) {
      print("[DEBUG HAJATO] Gagal koneksi ke API Dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }
}