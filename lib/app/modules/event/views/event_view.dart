import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/event_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class EventView extends GetView<EventController> {
  const EventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HajatAppBar(title: 'Buat Acara', showBack: false),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header illustration
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rencanakan Acara', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('Spesial Anda', style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            Text('Buat, kelola, dan undang tamu dengan mudah', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ),
                      const Icon(Icons.celebration_rounded, size: 56, color: Colors.white54),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('Detail Acara', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),

                // Form fields
                _FormLabel(label: 'Nama Acara'),
                TextField(
                  onChanged: controller.setNama,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Pernikahan Ahmad & Siti',
                    prefixIcon: Icon(Icons.celebration_rounded, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
                _FormLabel(label: 'Tanggal Acara'),
                Obx(() => GestureDetector(
                      onTap: () => controller.pickDate(context),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: controller.tanggal.value != null ? AppColors.primary : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              controller.formattedDate,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: controller.tanggal.value != null ? AppColors.textPrimary : AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
                _FormLabel(label: 'Lokasi'),
                TextField(
                  onChanged: controller.setLokasi,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan alamat atau nama tempat',
                    prefixIcon: Icon(Icons.location_on_rounded, color: AppColors.primary),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 28),
                GradientButton(
                  label: 'Simpan & Buat Undangan',
                  onTap: controller.saveEvent,
                  icon: Icons.arrow_forward_rounded,
                ),
                const SizedBox(height: 24),

                // Quick actions
                Text('Kelola Acara', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: _QuickActionCard(icon: Icons.people_rounded, label: 'Daftar Tamu', color: AppColors.primary, onTap: () => Get.toNamed('/guest-list'))),
                  const SizedBox(width: 12),
                  Expanded(child: _QuickActionCard(icon: Icons.qr_code_scanner_rounded, label: 'Scan QR', color: AppColors.secondary, onTap: () => Get.toNamed('/qr-scanner'))),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _QuickActionCard(icon: Icons.person_add_rounded, label: 'Tambah Tamu', color: AppColors.success, onTap: () => Get.toNamed('/guest-registration'))),
                  const SizedBox(width: 12),
                  Expanded(child: _QuickActionCard(icon: Icons.dashboard_rounded, label: 'Dasbor', color: AppColors.info, onTap: () => Get.toNamed('/dashboard'))),
                ]),
                const SizedBox(height: 100),
              ],
            ),
          ),
          const FloatingChatbotButton(),
        ],
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String label;
  const _FormLabel({required this.label});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      );
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: color))),
          ],
        ),
      ),
    );
  }
}
