import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/vendor_dashboard_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class VendorDashboardView extends GetView<VendorDashboardController> {
  const VendorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildStatsRow()),
          SliverToBoxAdapter(child: _buildServices()),
          SliverToBoxAdapter(child: _buildBookingList()),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B4FBA), Color(0xFF4F6AF5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Vendor Dashboard', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                Text('Mahkota WO', style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              ]),
              Row(children: [
                GestureDetector(
                  onTap: controller.goToVendorChat,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.chat_rounded, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.notifications_rounded, color: Colors.white, size: 22),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(() => _QuickStat(value: '${controller.totalBooking.value}', label: 'Pesanan', icon: Icons.receipt_rounded)),
                Container(width: 1, height: 32, color: Colors.white24),
                Obx(() => _QuickStat(value: formatRupiah(controller.totalPendapatan.value), label: 'Pendapatan', icon: Icons.payments_rounded)),
                Container(width: 1, height: 32, color: Colors.white24),
                Obx(() => _QuickStat(value: '${controller.services.length}', label: 'Layanan', icon: Icons.design_services_rounded)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Expanded(child: _ActionCard(
          icon: Icons.add_circle_rounded,
          label: 'Tambah Layanan',
          color: AppColors.primary,
          onTap: controller.goToNewService,
        )),
        const SizedBox(width: 12),
        Expanded(child: _ActionCard(
          icon: Icons.chat_bubble_rounded,
          label: 'Chat Pelanggan',
          color: AppColors.secondary,
          onTap: controller.goToVendorChat,
        )),
        const SizedBox(width: 12),
        Expanded(child: _ActionCard(
          icon: Icons.analytics_rounded,
          label: 'Statistik',
          color: AppColors.success,
          onTap: () {},
        )),
      ]),
    );
  }

  Widget _buildServices() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Layanan Saya',
            actionLabel: '+ Tambah',
            onAction: controller.goToNewService,
          ),
          const SizedBox(height: 12),
          Obx(() => controller.services.isEmpty
              ? const EmptyState(icon: Icons.design_services_rounded, title: 'Belum Ada Layanan', subtitle: 'Tambahkan layanan pertama Anda')
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.services.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final s = controller.services[i];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.design_services_rounded, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(s.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700)),
                              Text(formatRupiah(s.price),
                                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                            ]),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (v) {
                              if (v == 'edit') controller.editService(s);
                              if (v == 'delete') controller.deleteService(s.id);
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            itemBuilder: (_) => [
                              PopupMenuItem(value: 'edit', child: Row(children: [
                                const Icon(Icons.edit_rounded, size: 16, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text('Edit', style: GoogleFonts.poppins(fontSize: 13)),
                              ])),
                              PopupMenuItem(value: 'delete', child: Row(children: [
                                const Icon(Icons.delete_rounded, size: 16, color: AppColors.error),
                                const SizedBox(width: 8),
                                Text('Hapus', style: GoogleFonts.poppins(fontSize: 13)),
                              ])),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )),
        ],
      ),
    );
  }

  Widget _buildBookingList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Daftar Pesanan'),
          const SizedBox(height: 12),
          Obx(() => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final b = controller.bookings[i];
                  final isConfirmed = b['status'] == 'confirmed';
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                    ),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(b['customer'] as String, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700)),
                        Text('${b['package']} • ${b['date']}', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                        Text(formatRupiah(b['amount'] as int ), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                      ])),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isConfirmed ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isConfirmed ? 'Dikonfirmasi' : 'Menunggu',
                          style: GoogleFonts.poppins(
                            fontSize: 10, fontWeight: FontWeight.w600,
                            color: isConfirmed ? AppColors.success : AppColors.warning,
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              )),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _QuickStat({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) => Column(children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(label, style: GoogleFonts.poppins(color: Colors.white60, fontSize: 10)),
      ]);
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color), textAlign: TextAlign.center),
          ]),
        ),
      );
}
