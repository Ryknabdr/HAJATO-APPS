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
  label: _statusText(booking.bookingStatus),
  color: _statusColor(
    booking.bookingStatus,
  ),
),

_StatusChip(
  label: _statusText(booking.paymentStatus),
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
                      if (booking.bookingStatus == 'completed') ...[
                        const SizedBox(height: 12),

                        if (booking.hasReviewed)
                          Text(
                            'Ulasan sudah dikirim',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                            onPressed: () {

                              final commentController = TextEditingController();

                              int rating = 5;

                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Beri Ulasan'),

                                  content: StatefulBuilder(
                                    builder: (context, setState) {

                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: List.generate(5, (index) {
    final starValue = index + 1;

    return GestureDetector(
      onTap: () {
        setState(() {
          rating = starValue;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(
          starValue <= rating
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          color: AppColors.warning,
          size: 34,
        ),
      ),
    );
  }),
),

                                          const SizedBox(height: 12),

                                          TextField(
                                            controller: commentController,
                                            maxLines: 4,
                                            decoration: const InputDecoration(
                                              hintText: 'Tulis ulasan...',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                  actions: [

                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Batal'),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {

                                        controller.submitReview(
                                          bookingId: booking.id,
                                          rating: rating,
                                          comment: commentController.text,
                                        );
                                      },
                                      child: const Text('Kirim'),
                                    ),
                                  ],
                                ),
                              );
                            },
                              icon: const Icon(Icons.star_rounded),
                              label: const Text('Beri Ulasan'),
                            ),
                          ),
                      ],
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

  String _statusText(String status) {

  switch (status) {

    case 'pending_payment':
      return 'Menunggu Pembayaran';

    case 'paid':
      return 'Sudah Dibayar';

    case 'confirmed':
      return 'Dikonfirmasi';

    case 'completed':
      return 'Selesai';

    case 'released':
      return 'Dana Dicairkan';

    case 'hold':
      return 'Dana Ditahan';

    default:
      return status;
  }
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