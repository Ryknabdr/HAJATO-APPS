import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../controllers/booking_detail_controller.dart';
import 'dart:io';
import '../../../core/constants/api_config.dart';

class BookingDetailView extends GetView<BookingDetailController> {
  const BookingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = controller.booking;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: const HajatAppBar(title: 'Detail Pesanan'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.packageName,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    booking.vendorName,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _StatusChip(
                    label: booking.bookingStatus,
                    color: _statusColor(booking.bookingStatus),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _DetailCard(
              title: 'Informasi Acara',
              children: [
                _DetailItem(
                  icon: Icons.calendar_month_rounded,
                  label: 'Tanggal',
                  value: booking.eventDate,
                ),

                _DetailItem(
                  icon: Icons.access_time_rounded,
                  label: 'Jam',
                  value: booking.eventTime,
                ),

                _DetailItem(
                  icon: Icons.location_on_rounded,
                  label: 'Lokasi',
                  value: booking.location,
                ),
              ],
            ),

            const SizedBox(height: 18),

            _DetailCard(
              title: 'Pembayaran',
              children: [
                _DetailItem(
                  icon: Icons.payments_rounded,
                  label: 'Metode',
                  value: booking.paymentMethod,
                ),

                _DetailItem(
                  icon: Icons.receipt_long_rounded,
                  label: 'Status Payment',
                  value: booking.paymentStatus,
                ),
              ],
            ),

            const SizedBox(height: 18),

            const SizedBox(height: 18),

            _DetailCard(
              title: 'Bukti Pembayaran',
              children: [
                Obx(() {
                  final image = controller.selectedImage.value;

                  if (image != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),

                      child: Image.file(
                        image,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  }

                  if (booking.paymentProof.isNotEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),

                      child: Image.network(
                        '${ApiConfig.baseUrl}/uploads/payment_proofs/${booking.paymentProof}',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  }

                  return Text(
                    'Belum ada gambar dipilih',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  );
                }),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            booking.paymentStatus ==
                                    'waiting_admin_verification' ||
                                booking.paymentStatus == 'paid'
                            ? null
                            : controller.pickPaymentProof,
                        icon: const Icon(Icons.image_rounded),
                        label: const Text('Pilih Bukti'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            booking.paymentStatus ==
                                    'waiting_admin_verification' ||
                                booking.paymentStatus == 'paid'
                            ? null
                            : controller.uploadPaymentProof,
                        icon: const Icon(Icons.upload_rounded),
                        label: const Text('Upload'),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            _DetailCard(
              title: 'Progress Booking',
              children: [
                _TimelineItem(title: 'Booking Dibuat', active: true),

                _TimelineItem(
                  title: 'Bukti Pembayaran Diupload',
                  active: booking.paymentProof.isNotEmpty,
                ),

                _TimelineItem(
                  title: 'Booking Dikonfirmasi',
                  active: booking.bookingStatus == 'confirmed',
                ),

                _TimelineItem(
                  title: 'Dana Ditahan Sistem',
                  active: booking.vendorPayoutStatus == 'hold',
                ),

                _TimelineItem(
                  title: 'Dana Dicairkan ke Vendor',
                  active: booking.vendorPayoutStatus == 'released',
                  isLast: true,
                ),
              ],
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    formatRupiah(booking.totalPrice),
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == 'confirmed' || status == 'paid' || status == 'completed') {
      return AppColors.success;
    }

    if (status == 'rejected' || status == 'refund_required') {
      return AppColors.error;
    }

    return AppColors.warning;
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),

      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final bool active;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.active,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,

              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.grey.shade300,

                shape: BoxShape.circle,
              ),
            ),

            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: active
                    ? AppColors.primary.withOpacity(0.3)
                    : Colors.grey.shade300,
              ),
          ],
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),

            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
