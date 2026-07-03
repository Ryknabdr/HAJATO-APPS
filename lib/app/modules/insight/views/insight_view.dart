import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/insight_controller.dart';

class InsightView extends GetView<InsightController> {
  const InsightView({super.key});

  static const List<Color> _chartColors = [
    Color(0xFF6C63FF),
    Color(0xFFFF6584),
    Color(0xFF43BCCD),
    Color(0xFFFFB347),
    Color(0xFF4CAF50),
    Color(0xFF9C6ADE),
    Color(0xFFEF5350),
    Color(0xFF26A69A),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Color(0xFF1A1A2E),
          ),
        ),
        title: Text(
          'Insight & Inspirasi Hajatan',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.videos.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.refreshInsight,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            children: [
              _buildHeader(),
              const SizedBox(height: 16),

              if (controller.errorMessage.value.isNotEmpty) _buildErrorCard(),

              if (controller.errorMessage.value.isNotEmpty)
                const SizedBox(height: 16),

              _buildSummaryCards(),
              const SizedBox(height: 16),

              _buildLastUpdate(),
              const SizedBox(height: 24),

              _buildCategoryFilter(),
              const SizedBox(height: 20),

              if (controller.isLoading.value)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: LinearProgressIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

              if (controller.categoryStats.isNotEmpty) ...[
                _buildBarChart(),
                const SizedBox(height: 16),
                _buildPieChart(),
                const SizedBox(height: 24),
              ],

              _buildVideoHeader(),
              const SizedBox(height: 12),

              if (controller.videos.isEmpty)
                _buildEmptyVideo()
              else
                ...controller.videos.map(
                  (video) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildVideoCard(video),
                  ),
                ),

              if (controller.hasMoreVideos) _buildLoadMoreButton(),

              if (controller.isLoadingMore.value)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inspirasi untuk Acara Impianmu',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Temukan video terbaru seputar dekorasi, '
                  'makeup, catering, sound system, dan kebutuhan hajatan.',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.78),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              controller.errorMessage.value,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.red.shade700,
              ),
            ),
          ),
          TextButton(
            onPressed: controller.fetchInsightData,
            child: Text(
              'Coba Lagi',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RINGKASAN
  // ============================================================

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Total Video',
            value: controller.totalVideo.value.toString(),
            icon: Icons.video_library_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'Total Kategori',
            value: controller.totalKategori.value.toString(),
            icon: Icons.category_outlined,
            color: const Color(0xFFFF9F43),
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdate() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Icon(Icons.update_rounded, size: 19, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            'Terakhir diperbarui',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            controller.formattedLastUpdate,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER KATEGORI
  // ============================================================

  Widget _buildCategoryFilter() {
    final categories = controller.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter Kategori',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((kategori) {
              final bool selected =
                  controller.selectedCategory.value == kategori;

              final String label = kategori == 'semua'
                  ? 'Semua'
                  : _formatCategory(kategori);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  selected: selected,
                  showCheckmark: false,
                  label: Text(label),
                  onSelected: (_) {
                    controller.selectCategory(kategori);
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFFE7E7E7),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GRAFIK BATANG KATEGORI
  // ============================================================

  Widget _buildBarChart() {
    final stats = controller.categoryStats;

    int maxValue = 1;

    for (final item in stats) {
      final int jumlah = (item['jumlah'] as num?)?.toInt() ?? 0;

      if (jumlah > maxValue) {
        maxValue = jumlah;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jumlah Video per Kategori',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Jumlah video yang berhasil dikoleksi berdasarkan kategori',
            style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textHint),
          ),
          const SizedBox(height: 18),
          ...List.generate(stats.length, (index) {
            final item = stats[index];

            final String kategori = (item['kategori'] ?? '-').toString();

            final int jumlah = (item['jumlah'] as num?)?.toInt() ?? 0;

            final double progress = maxValue == 0 ? 0 : jumlah / maxValue;

            final Color color = _chartColors[index % _chartColors.length];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatCategory(kategori),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      Text(
                        '$jumlah video',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 9,
                      backgroundColor: color.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ============================================================
  // DIAGRAM LINGKARAN
  // ============================================================

  Widget _buildPieChart() {
    final stats = controller.categoryStats;

    int total = 0;

    for (final item in stats) {
      total += (item['jumlah'] as num?)?.toInt() ?? 0;
    }

    final sections = List.generate(stats.length, (index) {
      final item = stats[index];

      final int jumlah = (item['jumlah'] as num?)?.toInt() ?? 0;

      final double percentage = total == 0 ? 0 : (jumlah / total) * 100;

      return PieChartSectionData(
        color: _chartColors[index % _chartColors.length],
        value: jumlah.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 54,
        titleStyle: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      );
    });

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Komposisi Kategori Video',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Persentase video pada setiap kategori',
            style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textHint),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 190,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 3,
                centerSpaceRadius: 42,
                startDegreeOffset: -90,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: List.generate(stats.length, (index) {
              final item = stats[index];

              final String kategori = (item['kategori'] ?? '-').toString();

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: _chartColors[index % _chartColors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _formatCategory(kategori),
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DAFTAR VIDEO
  // ============================================================

  Widget _buildVideoHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            controller.selectedCategory.value == 'semua'
                ? 'Semua Inspirasi Video'
                : _formatCategory(controller.selectedCategory.value),
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${controller.videos.length} ditampilkan',
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    final String thumbnail = (video['thumbnail'] ?? '').toString();

    final String title = (video['title'] ?? 'Tanpa judul').toString();

    final String description = (video['description'] ?? '').toString();

    final String channel = (video['channel'] ?? '-').toString();

    final String kategori = (video['kategori'] ?? 'Inspirasi').toString();

    final String publishDate = (video['publish_date'] ?? '').toString();

    final String videoLink = (video['video_link'] ?? '').toString();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              controller.openYoutubeVideo(videoLink);
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  thumbnail.isNotEmpty
                      ? Image.network(
                          thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return _buildImagePlaceholder();
                          },
                        )
                      : _buildImagePlaceholder(),
                  Container(color: Colors.black.withOpacity(0.08)),
                  Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _formatCategory(kategori).toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (description.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 11),
                Row(
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 15,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        channel,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(publishDate),
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.openYoutubeVideo(videoLink);
                    },
                    icon: const Icon(
                      Icons.play_circle_outline_rounded,
                      size: 18,
                    ),
                    label: Text(
                      'Lihat Video',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.primary.withOpacity(0.06),
      child: Center(
        child: Icon(
          Icons.video_library_outlined,
          size: 42,
          color: AppColors.primary.withOpacity(0.35),
        ),
      ),
    );
  }

  Widget _buildEmptyVideo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 42,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 10),
          Text(
            'Video belum tersedia',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Belum ada video untuk kategori ini.',
            style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: OutlinedButton.icon(
        onPressed: controller.isLoadingMore.value
            ? null
            : controller.loadMoreVideos,
        icon: const Icon(Icons.expand_more_rounded, size: 20),
        label: Text(
          'Muat Video Lainnya',
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FORMAT DATA
  // ============================================================

  String _formatCategory(String value) {
    if (value.trim().isEmpty) {
      return 'Inspirasi';
    }

    return value
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  String _formatDate(String value) {
    if (value.isEmpty) {
      return '-';
    }

    final DateTime? date = DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// ============================================================
// KARTU RINGKASAN
// ============================================================

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
