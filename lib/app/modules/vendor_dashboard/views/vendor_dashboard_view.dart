import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/vendor_dashboard_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/api_config.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/models.dart';
import '../../../services/chat_service.dart';

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
        SliverToBoxAdapter(child: _buildExtraStats()),
        SliverToBoxAdapter(child: _buildQuickActions()),
        SliverToBoxAdapter(child: _buildServices()),
        SliverToBoxAdapter(child: _buildBookings()),
        SliverToBoxAdapter(child: _buildPayoutHistory()),
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

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
                    Obx(
                      () => Text(
                        controller.businessName.value.isEmpty
                            ? 'Vendor'
                            : controller.businessName.value,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () async {
                  await Get.toNamed(AppRoutes.notification);

                  controller.fetchUnreadNotifications();
                },
                child: Obx(
                  () => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const _HeaderIcon(
                        icon: Icons.notifications_outlined,
                      ),

                      if (controller.unreadNotifications.value > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                controller.unreadNotifications.value > 99
                                    ? '99+'
                                    : controller.unreadNotifications.value.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Obx(() {
                if (controller.vendorId.value.isEmpty) {
                  return GestureDetector(
                    onTap: controller.goToVendorChat,
                    child: _HeaderIcon(
                      icon: Icons.chat_bubble_outline_rounded,
                    ),
                  );
                }

                return StreamBuilder(
                  stream: ChatService.getUnreadVendorChats(
                    controller.vendorId.value,
                  ),
                  builder: (context, snapshot) {
                    final unreadCount = snapshot.hasData
                        ? snapshot.data!.docs.fold<int>(
                            0,
                            (sum, doc) {
                              final data = doc.data() as Map<String, dynamic>;

                              return sum + ((data['unread_vendor'] ?? 0) as int);
                            },
                          )
                        : 0;

                    print('TOTAL UNREAD CHAT: $unreadCount');

                    return GestureDetector(
                      onTap: controller.goToVendorChat,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _HeaderIcon(
                            icon: Icons.chat_bubble_outline_rounded,
                          ),

                          if (unreadCount > 0)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    unreadCount > 99 ? '99+' : '$unreadCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }),

              const SizedBox(width: 8),

              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.vendorProfile),
                child: _HeaderIcon(icon: Icons.person_outline_rounded),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Obx(
                () => _Chip(
                  label:
                      '⭐ ${controller.averageRating.value.toStringAsFixed(1)}',
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 6),
              Obx(
                () => _Chip(
                  label: controller.isVerified.value
                      ? '✓ Terverifikasi'
                      : '⏳ Menunggu',
                  color: controller.isVerified.value
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ),
              const SizedBox(width: 6),
              _Chip(label: '● Aktif', color: AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

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
            Obx(
              () => _StatCol(
                value: '${controller.totalBooking.value}',
                label: 'Pesanan',
              ),
            ),
            _VertDivider(),
            Obx(
              () => _StatCol(
                value: formatRupiah(controller.totalPendapatan.value),
                label: 'Pendapatan',
              ),
            ),
            _VertDivider(),
            Obx(
              () => _StatCol(
                value: controller.averageRating.value.toStringAsFixed(1),
                label: 'Rating',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtraStats() {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
    child: Column(
      children: [

        Row(
          children: [

            Expanded(
              child: Obx(
                () => _InfoStatCard(
                  title: 'Booking Selesai',
                  value:
                      '${controller.completedBooking.value}',
                  icon: Icons.check_circle_rounded,
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Obx(
                () => _InfoStatCard(
                  title: 'Total Ulasan',
                  value:
                      '${controller.totalReviews.value}',
                  icon: Icons.star_rounded,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [

            Expanded(
              child: Obx(
                () => _InfoStatCard(
                  title: 'Dana Dicairkan',
                  value: formatRupiah(
                    controller.danaDicairkan.value,
                  ),
                  icon: Icons.account_balance_wallet_rounded,
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Obx(
                () => _InfoStatCard(
                  title: 'Dana Ditahan',
                  value: formatRupiah(
                    controller.danaDitahan.value,
                  ),
                  icon: Icons.lock_clock_rounded,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

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
            onTap: controller.goToSchedule,
          ),
          _QuickAction(
            icon: Icons.bar_chart_rounded,
            label: 'Statistik',
            onTap: controller.goToStatistic,
          ),
          _QuickAction(
            icon: Icons.receipt_long_rounded,
            label: 'Pesanan\nMasuk',
            onTap: () => Get.toNamed(AppRoutes.vendorBookings),
          ),
        ],
      ),
    );
  }

  Widget _buildServices() {
    return _Section(
      title: 'Paket Layanan',
      action: '+ Tambah',
      onAction: controller.goToNewService,
      child: Obx(
        () => controller.services.isEmpty
            ? const _EmptyState(
                icon: Icons.design_services_outlined,
                message: 'Belum ada layanan',
              )
            : SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.services.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final s = controller.services[i];

                    return _ServiceCard(
                      name: s.name,
                      price: formatRupiah(s.price),
                      image: s.image,
                      onEdit: () => controller.editService(s),
                      onDelete: () => controller.deleteService(s.id),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildBookings() {
    return _Section(
      title: 'Pesanan Terbaru',
      child: Obx(
        () => controller.bookings.isEmpty
            ? const _EmptyState(
                icon: Icons.receipt_long_outlined,
                message: 'Belum ada pesanan',
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final booking = controller.bookings[i];

                  return _BookingCard(booking: booking);
                },
              ),
      ),
    );
  }

  Widget _buildPayoutHistory() {
  return _Section(
    title: 'Riwayat Pencairan Dana',
    child: Obx(
      () => controller.payouts.isEmpty
          ? const _EmptyState(
              icon: Icons.account_balance_wallet_outlined,
              message: 'Belum ada dana dicairkan',
            )
          : Column(
              children: controller.payouts.take(3).map((payout) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _PayoutCard(payout: payout),
                );
              }).toList(),
            ),
    ),
  );
}

  Widget _buildReviews() {
    return _Section(
      title: 'Ulasan Terbaru',
      child: Obx(
        () => controller.reviews.isEmpty
            ? const _EmptyState(
                icon: Icons.star_outline_rounded,
                message: 'Belum ada ulasan',
              )
            : Column(
                children: controller.reviews.take(3).map((review) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ReviewCard(
                      name: review.userName,
                      rating: review.rating.toInt(),
                      comment: review.comment,
                      date: review.date,
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}

String _formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);

    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${months[date.month]} ${date.year}';
  } catch (e) {
    return dateString;
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;

  const _HeaderIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: AppColors.textPrimary),
    );
  }
}

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
          style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: Colors.white24);
  }
}

class _InfoStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoStatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFEEEEEE),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            color: AppColors.primary,
            size: 22,
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textHint,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

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
  final String image;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ServiceCard({
    required this.name,
    required this.price,
    required this.image,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = image.isNotEmpty
        ? '${ApiConfig.baseUrl}/uploads/$image'
        : '';

    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 90,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 90,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                : Container(
                    height: 90,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
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

                const SizedBox(height: 10),

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
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final statusColor = booking.bookingStatus == 'confirmed'
        ? AppColors.success
        : booking.bookingStatus == 'rejected'
        ? AppColors.error
        : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.customerName.isEmpty ? 'Customer' : booking.customerName,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${booking.packageName} · ${booking.eventDate} · ${booking.eventTime}',
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
                formatRupiah(booking.totalPrice),
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
                  booking.bookingStatus,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
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

class _PayoutCard extends StatelessWidget {
  final PayoutHistoryModel payout;

  const _PayoutCard({required this.payout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.success,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payout.packageName,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${payout.customerName} · ${payout.eventDate}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),

          Text(
            formatRupiah(payout.totalPrice),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
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
                      _formatDate(date),
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
                    i < rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
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
