import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/api_config.dart';

class InsightController extends GetxController {
  // ============================================================
  // STATE LOADING DAN ERROR
  // ============================================================

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  // ============================================================
  // DATA VIDEO DAN STATISTIK
  // ============================================================

  final RxList<Map<String, dynamic>> videos =
      <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> categoryStats =
      <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> trendStats =
      <Map<String, dynamic>>[].obs;

  // ============================================================
  // FILTER KATEGORI
  // ============================================================

  final selectedCategory = 'semua'.obs;

  // ============================================================
  // DATA RINGKASAN
  // ============================================================

  final totalVideo = 0.obs;
  final totalKategori = 0.obs;
  final lastUpdate = ''.obs;

  // ============================================================
  // PAGINATION
  // ============================================================

  final currentPage = 1.obs;
  final totalPages = 1.obs;

  final int limitPerPage = 10;

  // ============================================================
  // SAAT CONTROLLER DIBUKA
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    fetchInsightData();
  }

  // ============================================================
  // MENGAMBIL SEMUA DATA AWAL
  // ============================================================

  Future<void> fetchInsightData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await fetchSummary();

      currentPage.value = 1;

      await fetchVideos(
        page: 1,
        replaceData: true,
      );
    } catch (e) {
      errorMessage.value =
          'Gagal memuat data Insight & Inspirasi Hajatan';

      print('FETCH INSIGHT DATA ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // MENGAMBIL RINGKASAN INSIGHT
  //
  // Endpoint:
  // /api/youtube/summary
  // ============================================================

  Future<void> fetchSummary() async {
    final Uri uri = Uri.parse(
      '${ApiConfig.baseUrl}/api/youtube/summary',
    );

    final response = await http.get(uri);

    print('INSIGHT SUMMARY STATUS: ${response.statusCode}');
    print('INSIGHT SUMMARY BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil ringkasan insight',
      );
    }

    final Map<String, dynamic> result =
        Map<String, dynamic>.from(
      jsonDecode(response.body),
    );

    if (result['status'] != 'success') {
      throw Exception(
        result['message'] ??
            'Ringkasan insight tidak tersedia',
      );
    }

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(
      result['data'] ?? {},
    );

    totalVideo.value =
        (data['total_video'] as num?)?.toInt() ?? 0;

    totalKategori.value =
        (data['total_kategori'] as num?)?.toInt() ?? 0;

    lastUpdate.value =
        (data['last_update'] ?? '').toString();

    final List<dynamic> stats =
        data['category_stats'] ?? [];

    categoryStats.assignAll(
      stats.map((item) {
        return Map<String, dynamic>.from(item);
      }).toList(),
    );

    final List<dynamic> trends =
        data['trend_stats'] ?? [];

    trendStats.assignAll(
      trends.map((item) {
        return Map<String, dynamic>.from(item);
      }).toList(),
    );
  }

  // ============================================================
  // MENGAMBIL DAFTAR VIDEO
  //
  // Endpoint:
  // /api/youtube/videos
  // ============================================================

  Future<void> fetchVideos({
    required int page,
    required bool replaceData,
  }) async {
    final Map<String, String> queryParameters = {
      'page': page.toString(),
      'limit': limitPerPage.toString(),
    };

    if (selectedCategory.value != 'semua') {
      queryParameters['kategori'] =
          selectedCategory.value;
    }

    final Uri uri = Uri.parse(
      '${ApiConfig.baseUrl}/api/youtube/videos',
    ).replace(
      queryParameters: queryParameters,
    );

    final response = await http.get(uri);

    print('INSIGHT VIDEOS STATUS: ${response.statusCode}');
    print('INSIGHT VIDEOS BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil daftar video',
      );
    }

    final Map<String, dynamic> result =
        Map<String, dynamic>.from(
      jsonDecode(response.body),
    );

    if (result['status'] != 'success') {
      throw Exception(
        result['message'] ??
            'Daftar video tidak tersedia',
      );
    }

    final List<dynamic> videoData =
        result['data'] ?? [];

    final List<Map<String, dynamic>> mappedVideos =
        videoData.map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();

    currentPage.value =
        (result['page'] as num?)?.toInt() ?? page;

    totalPages.value =
        (result['total_pages'] as num?)?.toInt() ?? 1;

    if (replaceData) {
      videos.assignAll(mappedVideos);
    } else {
      // Mencegah video yang sama masuk dua kali
      for (final video in mappedVideos) {
        final String videoId =
            (video['video_id'] ?? '').toString();

        final bool sudahAda = videos.any(
          (existingVideo) =>
              existingVideo['video_id'].toString() ==
              videoId,
        );

        if (!sudahAda) {
          videos.add(video);
        }
      }
    }
  }

  // ============================================================
  // MEMILIH KATEGORI
  // ============================================================

  Future<void> selectCategory(String kategori) async {
    if (selectedCategory.value == kategori) {
      return;
    }

    selectedCategory.value = kategori;
    currentPage.value = 1;
    errorMessage.value = '';

    try {
      isLoading.value = true;

      await fetchVideos(
        page: 1,
        replaceData: true,
      );
    } catch (e) {
      videos.clear();

      errorMessage.value =
          'Gagal memuat video kategori $kategori';

      print('FILTER INSIGHT ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // MEMUAT HALAMAN VIDEO BERIKUTNYA
  // ============================================================

  Future<void> loadMoreVideos() async {
    if (isLoadingMore.value) {
      return;
    }

    if (currentPage.value >= totalPages.value) {
      return;
    }

    try {
      isLoadingMore.value = true;

      final int nextPage = currentPage.value + 1;

      await fetchVideos(
        page: nextPage,
        replaceData: false,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal memuat video',
        'Video berikutnya tidak dapat dimuat.',
        snackPosition: SnackPosition.BOTTOM,
      );

      print('LOAD MORE INSIGHT ERROR: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ============================================================
  // REFRESH HALAMAN INSIGHT
  // ============================================================

  Future<void> refreshInsight() async {
    selectedCategory.value = 'semua';
    currentPage.value = 1;

    await fetchInsightData();
  }

  // ============================================================
  // DAFTAR KATEGORI UNTUK FILTER
  // ============================================================

  List<String> get categories {
    final List<String> result = ['semua'];

    for (final item in categoryStats) {
      final String kategori =
          (item['kategori'] ?? '').toString();

      if (kategori.isNotEmpty &&
          !result.contains(kategori)) {
        result.add(kategori);
      }
    }

    return result;
  }

  // ============================================================
  // CEK APAKAH MASIH ADA HALAMAN BERIKUTNYA
  // ============================================================

  bool get hasMoreVideos {
    return currentPage.value < totalPages.value;
  }

  // ============================================================
  // MEMBUKA VIDEO YOUTUBE
  // ============================================================

  Future<void> openYoutubeVideo(
    String videoLink,
  ) async {
    final Uri? uri = Uri.tryParse(videoLink);

    if (uri == null ||
        (uri.scheme != 'http' &&
            uri.scheme != 'https')) {
      Get.snackbar(
        'Link tidak valid',
        'Video tidak dapat dibuka.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    try {
      final bool berhasilDibuka = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!berhasilDibuka) {
        Get.snackbar(
          'Gagal membuka video',
          'Aplikasi YouTube atau browser tidak dapat dibuka.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Terjadi kesalahan',
        'Video tidak dapat dibuka.',
        snackPosition: SnackPosition.BOTTOM,
      );

      print('OPEN INSIGHT YOUTUBE ERROR: $e');
    }
  }

  // ============================================================
  // FORMAT WAKTU UPDATE
  // ============================================================

  String get formattedLastUpdate {
    if (lastUpdate.value.isEmpty) {
      return '-';
    }

    final DateTime? parsedDate =
        DateTime.tryParse(lastUpdate.value);

    if (parsedDate == null) {
      return lastUpdate.value;
    }

    // Waktu dari MongoDB dianggap sebagai UTC
    final DateTime utcDate = parsedDate.isUtc
        ? parsedDate
        : DateTime.utc(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            parsedDate.hour,
            parsedDate.minute,
            parsedDate.second,
            parsedDate.millisecond,
            parsedDate.microsecond,
          );

    // Konversi UTC menjadi WIB
    final DateTime wibDate =
        utcDate.add(const Duration(hours: 7));

    final String day =
        wibDate.day.toString().padLeft(2, '0');

    final String month =
        wibDate.month.toString().padLeft(2, '0');

    final String year = wibDate.year.toString();

    final String hour =
        wibDate.hour.toString().padLeft(2, '0');

    final String minute =
        wibDate.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute WIB';
  }
}