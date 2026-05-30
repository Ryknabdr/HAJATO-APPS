import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/payment_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/api_config.dart';

import '../../../routes/app_routes.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: const HajatAppBar(title: 'Pembayaran'),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    controller.formattedPrice,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 170,
              child: Obx(
                () => GradientButton(
                  label: controller.paymentSuccess.value
                      ? 'Cek Pesanan Saya'
                      : controller.isLoading.value
                      ? 'Memproses...'
                      : 'Bayar Sekarang',
                  onTap: controller.paymentSuccess.value
                      ? () => Get.offAllNamed(AppRoutes.myBookings)
                      : controller.isLoading.value
                      ? () {}
                      : controller.payWithMidtrans,
                  icon: controller.paymentSuccess.value
                      ? Icons.receipt_long_rounded
                      : Icons.payment_rounded,
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),

            const SizedBox(height: 20),

            _buildMidtransInfo(),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Pesanan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(14),

            child: Image.network(
              '${ApiConfig.baseUrl}/uploads/${controller.package.image}',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: AppColors.surfaceVariant,
                child: const Icon(
                  Icons.image_rounded,
                  size: 60,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            controller.package.name,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            controller.vendor.name,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          _InfoRow(
            icon: Icons.calendar_month_rounded,
            text: controller.formattedDate,
          ),

          const SizedBox(height: 10),

          _InfoRow(
            icon: Icons.people_rounded,
            text: '${controller.package.capacity} orang',
          ),

          const SizedBox(height: 10),

          _InfoRow(
            icon: Icons.schedule_rounded,
            text: '${controller.package.duration} jam',
          ),

          if (controller.notes.isNotEmpty) ...[
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.notes_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      controller.notes,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMidtransInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pembayaran Aman dengan Midtrans',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Kamu bisa memilih metode pembayaran langsung di halaman Midtrans.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          const _PaymentFeature(text: 'QRIS'),
          const _PaymentFeature(text: 'GoPay / E-Wallet'),
          const _PaymentFeature(text: 'Virtual Account'),
          const _PaymentFeature(text: 'Kartu Debit / Kredit'),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Text(
              'Dana akan ditahan oleh sistem HAJATO sampai acara selesai, lalu admin akan mencairkan dana ke vendor.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),

        const SizedBox(width: 8),

        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _PaymentFeature extends StatelessWidget {
  final String text;

  const _PaymentFeature({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: AppColors.primary,
          ),

          const SizedBox(width: 8),

          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
