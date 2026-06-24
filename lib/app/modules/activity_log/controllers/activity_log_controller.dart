import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_config.dart';

class ActivityLogController extends GetxController {
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  final logs = <Map<String, dynamic>>[].obs;

  final selectedCategory = 'semua'.obs;

  final currentPage = 1.obs;
  final hasMore = false.obs;

  final categories = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    setupCategoriesAndFetchLogs();
  }

  Future<void> setupCategoriesAndFetchLogs() async {
    await setupCategoriesByRole();
    await fetchMyActivityLogs(isRefresh: true);
  }

  Future<void> setupCategoriesByRole() async {
    final prefs = await SharedPreferences.getInstance();

    final role = prefs.getString('role') ?? 'user';

    if (role == 'vendor') {
      categories.assignAll([
        {
          'label': 'Semua',
          'value': 'semua',
        },
        {
          'label': 'Akun',
          'value': 'akun',
        },
        {
          'label': 'Booking',
          'value': 'booking',
        },
        {
          'label': 'Paket',
          'value': 'paket',
        },
        {
          'label': 'Dana',
          'value': 'dana',
        },
        {
          'label': 'Status Vendor',
          'value': 'status_vendor',
        },
      ]);
    } else {
      categories.assignAll([
        {
          'label': 'Semua',
          'value': 'semua',
        },
        {
          'label': 'Akun',
          'value': 'akun',
        },
        {
          'label': 'Booking',
          'value': 'booking',
        },
        {
          'label': 'Pembayaran',
          'value': 'pembayaran',
        },
        {
          'label': 'Review',
          'value': 'review',
        },
        {
          'label': 'Vendor',
          'value': 'vendor',
        },
      ]);
    }
  }

  Future<void> fetchMyActivityLogs({
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      isLoading.value = true;
      currentPage.value = 1;
      hasMore.value = false;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Gagal',
          'Token tidak ditemukan. Silakan login ulang.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/api/activity-logs/my'
        '?page=${currentPage.value}'
        '&limit=20'
        '&category=${selectedCategory.value}',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('ACTIVITY LOG STATUS : ${response.statusCode}');
      print('ACTIVITY LOG BODY : ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List rawLogs = data['data'] ?? [];

        final newLogs = rawLogs.map<Map<String, dynamic>>((item) {
          return {
            'id': item['id'],
            'action': item['action'] ?? '',
            'title': item['title'] ?? 'Aktivitas',
            'description': item['description'] ??
                'Anda melakukan aktivitas di aplikasi HAJATO.',
            'created_at': _formatDate(item['timestamp']),
            'timestamp': item['timestamp'],
            'metadata': item['metadata'] ?? {},
          };
        }).toList();

        if (isRefresh) {
          logs.assignAll(newLogs);
        } else {
          logs.addAll(newLogs);
        }

        final pagination = data['pagination'] ?? {};
        hasMore.value = pagination['has_more'] ?? false;
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Gagal mengambil log aktivitas',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('FETCH ACTIVITY LOG ERROR : $e');

      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> changeCategory(String category) async {
    selectedCategory.value = category;
    currentPage.value = 1;
    logs.clear();

    await fetchMyActivityLogs(isRefresh: true);
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) {
      return;
    }

    currentPage.value++;

    await fetchMyActivityLogs(isRefresh: false);
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) {
      return '-';
    }

    try {
      final dateTime = DateTime.parse(timestamp.toString()).toLocal();

      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year.toString();

      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return '$day/$month/$year, $hour:$minute';
    } catch (e) {
      return timestamp.toString();
    }
  }
}