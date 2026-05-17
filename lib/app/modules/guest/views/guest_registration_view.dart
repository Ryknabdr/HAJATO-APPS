import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/guest_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class GuestRegistrationView extends GetView<GuestController> {
  const GuestRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HajatAppBar(title: 'Daftar Tamu (RSVP)'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primary.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Form RSVP', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Text('Daftarkan tamu dan konfirmasi kehadiran', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Informasi Tamu', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),

            // Nama field
            _FieldLabel('Nama Lengkap'),
            TextField(
              onChanged: (v) => controller.nama.value = v,
              decoration: const InputDecoration(
                hintText: 'Masukkan nama lengkap',
                prefixIcon: Icon(Icons.person_rounded, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),

            // Nomor HP
            _FieldLabel('Nomor HP'),
            TextField(
              onChanged: (v) => controller.nomorHP.value = v,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Contoh: 081234567890',
                prefixIcon: Icon(Icons.phone_rounded, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),

            // Kehadiran
            _FieldLabel('Status Kehadiran'),
            Obx(() => Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.hadir.value = true,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: controller.hadir.value ? AppColors.primaryGradient : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: controller.hadir.value ? Colors.white : AppColors.textHint, size: 18),
                                const SizedBox(width: 6),
                                Text('Hadir',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: controller.hadir.value ? Colors.white : AppColors.textHint)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.hadir.value = false,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !controller.hadir.value ? AppColors.error : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cancel_rounded,
                                    color: !controller.hadir.value ? Colors.white : AppColors.textHint, size: 18),
                                const SizedBox(width: 6),
                                Text('Tidak Hadir',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: !controller.hadir.value ? Colors.white : AppColors.textHint)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 32),

            GradientButton(
              label: 'Daftarkan Tamu',
              onTap: controller.registerGuest,
              icon: Icons.how_to_reg_rounded,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Get.toNamed('/guest-list'),
              icon: const Icon(Icons.list_rounded),
              label: const Text('Lihat Daftar Tamu'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      );
}
