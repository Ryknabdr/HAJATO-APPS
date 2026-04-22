import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/dashboard_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildStatCards()),
              SliverToBoxAdapter(child: _buildGuestChart()),
              SliverToBoxAdapter(child: _buildVendorSummary()),
              SliverToBoxAdapter(child: _buildRecentActivity()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          const FloatingChatbotButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dasbor Acara', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                  Text('Rangkuman Acara Anda', style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                const Icon(Icons.celebration_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Acara Aktif', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
                    Text('Pernikahan Ahmad & Siti', style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(8)),
                  child: Text('Aktif', style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() => Column(
            children: [
              Row(children: [
                Expanded(child: StatCard(
                  label: 'Total Tamu',
                  value: '${controller.totalTamu.value}',
                  icon: Icons.people_rounded,
                  color: AppColors.primary,
                  gradient: AppColors.primaryGradient,
                )),
                const SizedBox(width: 12),
                Expanded(child: StatCard(
                  label: 'Tamu Hadir',
                  value: '${controller.tamuHadir.value}',
                  icon: Icons.how_to_reg_rounded,
                  color: AppColors.success,
                )),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: StatCard(
                  label: 'Check-in',
                  value: '${controller.tamuSudahCheckIn.value}',
                  icon: Icons.verified_rounded,
                  color: AppColors.info,
                )),
                const SizedBox(width: 12),
                Expanded(child: StatCard(
                  label: 'Total Vendor',
                  value: '${controller.totalVendor.value}',
                  icon: Icons.store_rounded,
                  color: AppColors.secondary,
                )),
              ]),
            ],
          )),
    );
  }

  Widget _buildGuestChart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tamu per Hari', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                  child: Text('7 Hari', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: Obx(() => LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) {
                              const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
                              if (v.toInt() < days.length) {
                                return Text(days[v.toInt()],
                                    style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textHint));
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: controller.weeklyData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                          isCurved: true,
                          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                          barWidth: 3,
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorSummary() {
    final vendors = [
      {'name': 'Lensa Pro Studio', 'cat': 'Fotografer', 'status': 'confirmed', 'icon': Icons.photo_camera_rounded},
      {'name': 'Nusantara Catering', 'cat': 'Catering', 'status': 'pending', 'icon': Icons.restaurant_rounded},
      {'name': 'Mahkota WO', 'cat': 'Wedding Organizer', 'status': 'confirmed', 'icon': Icons.favorite_rounded},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Vendor Dipesan', actionLabel: 'Lihat Semua'),
          const SizedBox(height: 12),
          ...vendors.map((v) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(v['icon'] as IconData, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(v['name'] as String, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(v['cat'] as String, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: v['status'] == 'confirmed' ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        v['status'] == 'confirmed' ? 'Dikonfirmasi' : 'Menunggu',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: v['status'] == 'confirmed' ? AppColors.success : AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {'icon': Icons.how_to_reg_rounded, 'text': 'Ahmad Fauzi melakukan check-in', 'time': '5 menit lalu', 'color': AppColors.success},
      {'icon': Icons.person_add_rounded, 'text': 'Dewi Lestari didaftarkan sebagai tamu', 'time': '1 jam lalu', 'color': AppColors.info},
      {'icon': Icons.store_rounded, 'text': 'Pesanan Catering dikonfirmasi', 'time': '3 jam lalu', 'color': AppColors.primary},
      {'icon': Icons.qr_code_rounded, 'text': 'QR Code digenerate untuk 7 tamu', 'time': '5 jam lalu', 'color': AppColors.secondary},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Aktivitas Terbaru'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
              itemBuilder: (_, i) {
                final a = activities[i];
                return Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (a['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(a['text'] as String, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
                          Text(a['time'] as String, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textHint)),
                        ]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
