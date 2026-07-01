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
    final String? eventIdFromArgs = Get.arguments;
    if (eventIdFromArgs != null && eventIdFromArgs.isNotEmpty) {
      controller.currentEventId = eventIdFromArgs;
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HajatAppBar(title: 'Tambah Tamu Darurat'),
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
                        Text('Registrasi Kilat', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Text('Input tamu dadakan di lokasi. Otomatis terkonfirmasi Hadir.', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
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
            const _FieldLabel('Nama Lengkap'),
            TextField(
              onChanged: (v) => controller.nama.value = v, 
              decoration: const InputDecoration(
                hintText: 'Masukkan nama lengkap',
                prefixIcon: Icon(Icons.person_rounded, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),

            // ── 🟢 REVISI UTAMA: NOMOR HP DIGANTI JADI ASAL / ROMBONGAN ──
            const _FieldLabel('Asal / Rombongan'),
            TextField(
              onChanged: (v) => controller.nomorHP.value = v, // 🟢 Tetap lempar ke variabel ini dulu biar lo gak perlu bikin variabel baru di controller, tinggal ganti isinya aja
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Contoh: Teman Kuliah, Keluarga Pekalongan, RT 02',
                prefixIcon: Icon(Icons.location_city_rounded, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 32),

            // Button Pendaftaran
            Obx(() => controller.isLoading.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                : GradientButton(
                    label: 'Konfirmasi Masuk',
                    onTap: controller.registerGuest,
                    icon: Icons.how_to_reg_rounded,
                  )),
            const SizedBox(height: 12),
            
            OutlinedButton.icon(
              onPressed: () => Get.toNamed('/guest-list', arguments: controller.currentEventId), 
              icon: const Icon(Icons.list_rounded),
              label: const Text('Lihat Daftar Tamu'),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
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