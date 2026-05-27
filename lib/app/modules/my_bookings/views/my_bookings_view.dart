import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../routes/app_routes.dart';
import '../controllers/my_bookings_controller.dart';

class MyBookingsView extends GetView<MyBookingsController> {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HajatAppBar(title: 'Pesanan Saya'),

      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.bookings.isEmpty) {
          return Center(
            child: Text(
              'Belum ada pesanan',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchBookings,

          child: ListView.separated(
            padding: const EdgeInsets.all(20),

            itemCount: controller.bookings.length,

            separatorBuilder: (_, __) =>
                const SizedBox(height: 14),

            itemBuilder: (_, i) {

              final booking = controller.bookings[i];

              return GestureDetector(

                onTap: () => Get.toNamed(
                  AppRoutes.bookingDetail,
                  arguments: booking,
                ),

                child: Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        booking.packageName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        booking.vendorName,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [

                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),

                          const SizedBox(width: 6),

                          Expanded(
                            child: Text(
                              booking.eventDate,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [

                          const Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            booking.eventTime,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [

                          _StatusChip(
                            label: booking.bookingStatus,
                            color: _statusColor(
                              booking.bookingStatus,
                            ),
                          ),

                          _StatusChip(
                            label: booking.paymentStatus,
                            color: _statusColor(
                              booking.paymentStatus,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        formatRupiah(
                          booking.totalPrice,
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Color _statusColor(String status) {

    if (
        status == 'confirmed' ||
        status == 'paid' ||
        status == 'completed' ||
        status == 'released'
    ) {
      return AppColors.success;
    }

    if (
        status == 'rejected' ||
        status == 'refund_required'
    ) {
      return AppColors.error;
    }

    return AppColors.warning;
  }
}

class _StatusChip extends StatelessWidget {

  final String label;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
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