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
      backgroundColor: const Color(0xFFF9F9F9),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildStats()),
          SliverToBoxAdapter(child: _buildQuickActions()),
          SliverToBoxAdapter(child: _buildServices()),
          SliverToBoxAdapter(child: _buildBookings()),
          SliverToBoxAdapter(child: _buildReviews()),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToNewService,
        backgroundColor: AppColors.primary,
        elevation: 2,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  // ── HEADER ───────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'M',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                    Text(
                      'Mahkota Wedding Organizer',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Notif
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.notifications_outlined,
                      size: 20, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: controller.goToVendorChat,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.chat_bubble_outline_rounded,
                      size: 20, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Status badges — ramping
          Row(
            children: [
              _Chip(label: '⭐ 4.9', color: AppColors.warning),
              const SizedBox(width: 6),
              Obx(() => _Chip(
                    label: controller.isVerified.value
                        ? '✓ Terverifikasi'
                        : '⏳ Menunggu',
                    color: controller.isVerified.value
                        ? AppColors.success
                        : AppColors.warning,
                  )),
              const SizedBox(width: 6),
              _Chip(label: '● Aktif', color: AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  // ── STATS ────────────────────────────────────────────────
  Widget _buildStats() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(() => _StatCol(
                  value: '${controller.totalBooking.value}',
                  label: 'Pesanan',
                )),
            _VertDivider(),
            Obx(() => _StatCol(
                  value: formatRupiah(controller.totalPendapatan.value),
                  label: 'Pendapatan',
                )),
            _VertDivider(),
            Obx(() => _StatCol(
                  value: '${controller.services.length}',
                  label: 'Layanan',
                )),
          ],
        ),
      ),
    );
  }

  // ── QUICK ACTIONS ─────────────────────────────────────────
  Widget _buildQuickActions() {
    return _Section(
      title: 'Aksi Cepat',
      child: Row(
        children: [
          _QuickAction(
            icon: Icons.add_circle_outline_rounded,
            label: 'Tambah\nLayanan',
            onTap: controller.goToNewService,
          ),
          _QuickAction(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat\nPelanggan',
            onTap: controller.goToVendorChat,
          ),
          _QuickAction(
            icon: Icons.calendar_today_outlined,
            label: 'Jadwal\nAcara',
            onTap: () {},
          ),
          _QuickAction(
            icon: Icons.bar_chart_rounded,
            label: 'Statistik',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── SERVICES ─────────────────────────────────────────────
  Widget _buildServices() {
    return _Section(
      title: 'Paket Layanan',
      action: '+ Tambah',
      onAction: controller.goToNewService,
      child: Obx(() => controller.services.isEmpty
          ? _EmptyState(
              icon: Icons.design_services_outlined,
              message: 'Belum ada layanan',
            )
          : SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.services.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final s = controller.services[i];
                  return _ServiceCard(
                    name: s.name,
                    price: formatRupiah(s.price),
                    onEdit: () => controller.editService(s),
                    onDelete: () => controller.deleteService(s.id),
                  );
                },
              ),
            )),
    );
  }

  // ── BOOKINGS ──────────────────────────────────────────────
  Widget _buildBookings() {
    return _Section(
      title: 'Pesanan Terbaru',
      child: Obx(() => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _BookingCard(booking: controller.bookings[i]),
          )),
    );
  }

  // ── REVIEWS ───────────────────────────────────────────────
  Widget _buildReviews() {
    return _Section(
      title: 'Ulasan Terbaru',
      child: Column(
        children: [
          _ReviewCard(
            name: 'Siti Rahayu',
            rating: 5,
            comment:
                'Pelayanannya sangat memuaskan! Dekorasi sesuai ekspektasi dan tim sangat profesional.',
            date: '15 Mei 2025',
          ),
          const SizedBox(height: 8),
          _ReviewCard(
            name: 'Ahmad Fauzi',
            rating: 4,
            comment: 'Koordinasi acara berjalan lancar. Sangat direkomendasikan.',
            date: '2 Apr 2025',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SHARED LAYOUT WIDGET
// ─────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final Widget child;

  const _Section({
    required this.title,
    required this.child,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (action != null)
                GestureDetector(
                  onTap: onAction,
                  child: Text(
                    action!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SMALL COMPONENTS
// ─────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  final String value;
  final String label;
  const _StatCol({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white60,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 32, color: Colors.white24);
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 22, color: AppColors.primary),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String name;
  final String price;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ServiceCard({
    required this.name,
    required this.price,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  'Edit',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onDelete,
                child: Text(
                  'Hapus',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final isConfirmed = booking['status'] == 'confirmed';
    final statusColor = isConfirmed ? AppColors.success : AppColors.warning;
    final statusLabel = isConfirmed ? 'Dikonfirmasi' : 'Menunggu';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          // Avatar inisial
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                (booking['customer'] as String)[0],
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['customer'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${booking['package']} · ${booking['date']}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatRupiah(booking['amount'] as int),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              if (!isConfirmed) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Konfirmasi →',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;
  final String date;
  const _ReviewCard({
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    name[0],
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: AppColors.warning,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(icon, size: 36, color: AppColors.textHint),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}