import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/qr_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class QrCodeView extends GetView<QrController> {
  const QrCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final guest = controller.currentGuest.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HajatAppBar(title: 'QR Code Tamu'),
      body: guest == null
          ? const EmptyState(icon: Icons.qr_code_rounded, title: 'Tidak Ada Data', subtitle: 'Tamu tidak ditemukan')
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // QR Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withOpacity(0.12), blurRadius: 30, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20)),
                              child: Text('HAJATO', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 2)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // QR Code
                        QrImageView(
                          data: guest.qrData ?? 'HAJATO-${guest.id}',
                          version: QrVersions.auto,
                          size: 220,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Color(0xFF4F6AF5)),
                          dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Color(0xFF1A1D2E)),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),
                        // Guest info
                        Text(guest.nama, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text(guest.nomorHP, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _StatusBadge(
                              label: guest.hadir ? 'Konfirmasi Hadir' : 'Tidak Hadir',
                              color: guest.hadir ? AppColors.success : AppColors.error,
                              icon: guest.hadir ? Icons.check_circle_rounded : Icons.cancel_rounded,
                            ),
                            if (guest.checkedIn) ...[
                              const SizedBox(width: 8),
                              const _StatusBadge(label: 'Sudah Check-in', color: AppColors.info, icon: Icons.verified_rounded),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        GradientButton(
                          label: 'Unduh QR Code',
                          onTap: () => Get.snackbar('Info', 'Mengunduh QR Code...', snackPosition: SnackPosition.BOTTOM),
                          icon: Icons.download_rounded,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => Get.snackbar('Berbagi', 'Membagikan QR Code...', snackPosition: SnackPosition.BOTTOM),
                          icon: const Icon(Icons.share_rounded),
                          label: const Text('Bagikan QR Code'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => Get.toNamed('/qr-scanner'),
                          icon: const Icon(Icons.qr_code_scanner_rounded),
                          label: const Text('Buka QR Scanner'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _StatusBadge({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ]),
      );
}
