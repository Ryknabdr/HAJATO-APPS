import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/vendor_dashboard_controller.dart';
import '../../../core/theme/app_theme.dart';
import 'dart:io';

class ManageServiceView extends GetView<VendorDashboardController> {
  const ManageServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController(text: controller.serviceName.value);
    final descCtrl = TextEditingController(
      text: controller.serviceDescription.value,
    );
    final priceCtrl = TextEditingController(
      text: controller.servicePrice.value > 0
          ? controller.servicePrice.value.toString()
          : '',
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.isEditing.value ? 'Edit Layanan' : 'Tambah Layanan',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Upload foto ──────────────────────────────────────────────────
            GestureDetector(
              onTap: controller.pickImage,
              child: Obx(
                () => Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.25),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: controller.imagePath.value.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(
                            File(controller.imagePath.value),
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Upload Foto Layanan',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'JPG, PNG maks. 5MB',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),

            // ── Kategori chips ───────────────────────────────────────────────
            _Label('Kategori Layanan'),
            const SizedBox(height: 8),
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _CategoryChip(
                      'Fotografer',
                      Icons.camera_alt_rounded,
                      controller.serviceCategory.value == 'Fotografer',
                      () => controller.serviceCategory.value = 'Fotografer',
                    ),

                    _CategoryChip(
                      'Catering',
                      Icons.restaurant_rounded,
                      controller.serviceCategory.value == 'Catering',
                      () => controller.serviceCategory.value = 'Catering',
                    ),

                    _CategoryChip(
                      'Tenda',
                      Icons.home_rounded,
                      controller.serviceCategory.value == 'Tenda',
                      () => controller.serviceCategory.value = 'Tenda',
                    ),

                    _CategoryChip(
                      'Dekorasi',
                      Icons.auto_awesome_rounded,
                      controller.serviceCategory.value == 'Dekorasi',
                      () => controller.serviceCategory.value = 'Dekorasi',
                    ),

                    _CategoryChip(
                      'Wedding',
                      Icons.favorite_rounded,
                      controller.serviceCategory.value == 'Wedding',
                      () => controller.serviceCategory.value = 'Wedding',
                    ),

                    _CategoryChip(
                      'Makeup',
                      Icons.face_rounded,
                      controller.serviceCategory.value == 'Makeup',
                      () => controller.serviceCategory.value = 'Makeup',
                    ),

                    _CategoryChip(
                      'Sound System',
                      Icons.music_note_rounded,
                      controller.serviceCategory.value == 'Sound System',
                      () => controller.serviceCategory.value = 'Sound System',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Nama layanan ─────────────────────────────────────────────────
            _Label('Nama Layanan'),
            _InputField(
              controller: nameCtrl,
              hint: 'Contoh: Paket Premium Wedding',
              icon: Icons.design_services_rounded,
              onChanged: (v) => controller.serviceName.value = v,
            ),
            const SizedBox(height: 16),

            // ── Deskripsi ────────────────────────────────────────────────────
            _Label('Deskripsi Layanan'),
            _InputField(
              controller: descCtrl,
              hint: 'Jelaskan detail layanan Anda secara lengkap...',
              icon: Icons.notes_rounded,
              maxLines: 4,
              onChanged: (v) => controller.serviceDescription.value = v,
            ),
            const SizedBox(height: 16),

            // ── Harga ─────────────────────────────────────────────────────────
            _Label('Harga Layanan (Rp)'),
            _InputField(
              controller: priceCtrl,
              hint: 'Contoh: 2500000',
              icon: Icons.payments_rounded,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              prefixText: 'Rp  ',
              onChanged: (v) =>
                  controller.servicePrice.value = int.tryParse(v) ?? 0,
            ),
            const SizedBox(height: 16),

            // ── Kapasitas ─────────────────────────────────────────────────────
            _Label('Kapasitas Tamu (opsional)'),
            _InputField(
              controller: TextEditingController(
                text: controller.serviceCapacity.value,
              ),
              hint: 'Contoh: 200',
              icon: Icons.people_rounded,
              keyboardType: TextInputType.number,
              suffixText: 'orang',
              onChanged: (v) => controller.serviceCapacity.value = v,
            ),
            const SizedBox(height: 16),

            // ── Durasi ────────────────────────────────────────────────────────
            _Label('Durasi Layanan (opsional)'),
            _InputField(
              controller: TextEditingController(
                text: controller.serviceDuration.value,
              ),
              hint: 'Contoh: 8',
              icon: Icons.schedule_rounded,
              keyboardType: TextInputType.number,
              suffixText: 'jam',
              onChanged: (v) => controller.serviceDuration.value = v,
            ),
            const SizedBox(height: 20),

            // ── Tips box ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.tips_and_updates_rounded,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tips dari Hajato',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Layanan dengan foto & deskripsi lengkap mendapat 3x lebih banyak klik dari calon pelanggan.',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.secondary.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Tombol simpan ─────────────────────────────────────────────────
            GestureDetector(
              onTap: controller.addOrUpdateService,
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => Text(
                        controller.isEditing.value
                            ? 'Simpan Perubahan'
                            : 'Tambah Layanan',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol batal (hanya saat edit)
            Obx(
              () => controller.isEditing.value
                  ? GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFB2DFDB),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Batal',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets pembantu ──────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      ),
    ),
  );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final String? suffixText;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
    this.suffixText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    maxLines: maxLines,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    onChanged: onChanged,
    style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.textHint),
      prefixIcon: Icon(
        icon,
        size: 18,
        color: AppColors.primary.withOpacity(0.6),
      ),
      prefixText: prefixText,
      prefixStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      suffixText: suffixText,
      suffixStyle: GoogleFonts.poppins(fontSize: 13, color: AppColors.textHint),
      filled: true,
      fillColor: AppColors.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFB2DFDB), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFB2DFDB), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
  );
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip(this.label, this.icon, this.selected, this.onTap);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        gradient: selected ? AppColors.primaryGradient : null,
        color: selected ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? Colors.transparent : const Color(0xFFB2DFDB),
          width: 1.5,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: selected ? Colors.white : AppColors.textHint,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}
