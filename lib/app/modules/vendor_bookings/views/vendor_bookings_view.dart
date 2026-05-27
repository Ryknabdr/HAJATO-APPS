import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../data/models/models.dart';
import '../controllers/vendor_bookings_controller.dart';

class VendorBookingsView extends GetView<VendorBookingsController> {
  const VendorBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: const HajatAppBar(title: 'Pesanan Vendor'),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bookings.isEmpty) {
          return Center(
            child: Text(
              'Belum ada pesanan masuk',
              style: GoogleFonts.poppins(),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.bookings.length,

          itemBuilder: (context, index) {
            final booking = controller.bookings[index];

            return _BookingCard(booking: booking);
          },
        );
      }),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.customerName.isEmpty
                          ? 'Customer'
                          : booking.customerName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${booking.packageName} · ${booking.eventDate} · ${booking.eventTime}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              _StatusBadge(status: booking.bookingStatus),
            ],
          ),

          const SizedBox(height: 18),

          _Item(icon: Icons.access_time_rounded, label: booking.eventTime),

          _Item(icon: Icons.location_on_rounded, label: booking.location),

          _Item(icon: Icons.payments_rounded, label: booking.paymentMethod),

          _Item(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Payout: ${booking.vendorPayoutStatus}',
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Text(
              formatRupiah(booking.totalPrice),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),

          if (booking.bookingStatus == 'confirmed') ...[
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  Get.find<VendorBookingsController>().completeBooking(
                    booking.id,
                  );
                },

                icon: const Icon(Icons.check_circle_rounded),

                label: const Text('Tandai Acara Selesai'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Item({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),

          const SizedBox(width: 10),

          Expanded(
            child: Text(label, style: GoogleFonts.poppins(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.warning;

    if (status == 'confirmed') {
      color = AppColors.success;
    }

    if (status == 'completed') {
      color = Colors.blue;
    }

    if (status == 'rejected') {
      color = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),

      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),

      child: Text(
        status,
        style: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}
