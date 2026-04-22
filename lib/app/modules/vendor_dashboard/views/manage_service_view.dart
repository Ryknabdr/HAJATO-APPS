import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/vendor_dashboard_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class ManageServiceView extends GetView<VendorDashboardController> {
  const ManageServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HajatAppBar(title: controller.isEditing.value ? 'Edit Layanan' : 'Tambah Layanan'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload image area
            GestureDetector(
              onTap: () => Get.snackbar('Info', 'Pilih gambar dari galeri', snackPosition: SnackPosition.BOTTOM),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2, style: BorderStyle.solid),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_photo_alternate_rounded, color: AppColors.primary, size: 32),
                      ),
                      const SizedBox(height: 10),
                      Text('Upload Foto Layanan', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                      Text('Tap untuk memilih gambar', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textHint)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Informasi Layanan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),

            _Label('Nama Layanan'),
            TextField(
              onChanged: (v) => controller.serviceName.value = v,
              controller: TextEditingController(text: controller.serviceName.value)..selection = TextSelection.collapsed(offset: controller.serviceName.value.length),
              decoration: const InputDecoration(
                hintText: 'Contoh: Paket Premium Wedding',
                prefixIcon: Icon(Icons.design_services_rounded, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),

            _Label('Deskripsi'),
            TextField(
              onChanged: (v) => controller.serviceDescription.value = v,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Jelaskan detail layanan Anda...',
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              ),
            ),
            const SizedBox(height: 16),

            _Label('Harga (Rp)'),
            TextField(
              onChanged: (v) => controller.servicePrice.value = int.tryParse(v.replaceAll('.', '')) ?? 0,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Contoh: 2500000',
                prefixIcon: Icon(Icons.payments_rounded, color: AppColors.primary),
                prefixText: 'Rp ',
              ),
            ),
            const SizedBox(height: 16),

            // Feature tips
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.info.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tips_and_updates_rounded, color: AppColors.info, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tips: Tambahkan foto berkualitas tinggi dan deskripsi lengkap untuk menarik lebih banyak pelanggan.',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.info, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            GradientButton(
              label: controller.isEditing.value ? 'Simpan Perubahan' : 'Tambah Layanan',
              onTap: controller.addOrUpdateService,
              icon: Icons.check_circle_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      );
}
