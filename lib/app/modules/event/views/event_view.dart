import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/event_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../routes/app_routes.dart';

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
                // Header Banner Ilustrasi
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

                // Drodown Kategori Acara
                const _FormLabel(label: 'Jenis / Kategori Acara'),
                Obx(() {
                  final currentCategory = controller.selectedCategory.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        value: currentCategory,
                        dropdownColor: Colors.white,
                        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(border: InputBorder.none, prefixIcon: Icon(Icons.category_rounded, color: AppColors.primary)),
                        items: const [
                          DropdownMenuItem(value: 'wedding', child: Text('💍 Pernikahan (Wedding)')),
                          DropdownMenuItem(value: 'khitanan', child: Text('👦 Sunatan (Khitanan)')),
                          DropdownMenuItem(value: 'formal', child: Text('🏢 Acara Formal / Umum (Webinar/Rapat)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            controller.selectedCategory.value = val;
                          }
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Form Fields Utama dengan Controller Baru
                const _FormLabel(label: 'Nama Acara'),
                Obx(() {
                  String hintText = 'Contoh: Pernikahan Ahmad & Siti';
                  if (controller.selectedCategory.value == 'khitanan') hintText = 'Contoh: Tasyakuran Khitanan Putra Rian';
                  if (controller.selectedCategory.value == 'formal') hintText = 'Contoh: Webinar Cyber Security Nasional';
                  
                  return TextField(
                    // 🟢 FIX MUTLAK: Sekarang diikat langsung menggunakan nameController
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      hintText: hintText,
                      prefixIcon: const Icon(Icons.celebration_rounded, color: AppColors.primary),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                
                const _FormLabel(label: 'Tanggal Acara'),
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
                const _FormLabel(label: 'Lokasi Fisik (Alamat)'),
                TextField(
                  // 🟢 FIX MUTLAK: Sekarang diikat langsung menggunakan locationController
                  controller: controller.locationController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan alamat gedung atau tempat acara',
                    prefixIcon: Icon(Icons.location_on_rounded, color: AppColors.primary),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),

                _buildMapsInput(),
                const SizedBox(height: 20),

                _buildRekeningInput(),
                const SizedBox(height: 20),

                _buildRundownSection(context),
                const SizedBox(height: 20),

                Obx(() {
                  if (controller.selectedCategory.value == 'formal') {
                    return const SizedBox.shrink();
                  }
                  return _buildDynamicGallerySection(context);
                }),
                const SizedBox(height: 24),

                const _FormLabel(label: 'Desain / Tema Tampilan Undangan'),
                Obx(() {
                  String templateLabel = 'Template 1 - Klasik Elegant (Default)';
                  if (controller.selectedTemplate.value == 'template_2') templateLabel = 'Template 2 - Rustic Elegant';
                  if (controller.selectedTemplate.value == 'template_3') templateLabel = 'Template 3 - Navy Bliss';
                  if (controller.selectedTemplate.value == 'template_4') templateLabel = 'Template 4 - Rose Blossom';
                  if (controller.selectedTemplate.value == 'template_5') templateLabel = 'Template 5 - Emerald Forest';
                  if (controller.selectedTemplate.value == 'template_6') templateLabel = 'Template 6 - Maroon Majesty';
                  if (controller.selectedTemplate.value == 'template_7') templateLabel = 'Template 7 - Minimalist Grey';
                  if (controller.selectedTemplate.value == 'template_8') templateLabel = 'Template 8 - Vintage Sepia';
                  if (controller.selectedTemplate.value == 'template_9') templateLabel = 'Template 9 - Orchid Purple';
                  if (controller.selectedTemplate.value == 'template_10') templateLabel = 'Template 10 - Tropical Vibes';

                  return GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.templateSelection),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.palette_rounded, color: AppColors.primary, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(templateLabel, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                Text('Ketuk di sini untuk melihat pratinjau & ganti desain', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 32),
                
                // Button Simpan Utama dengan Loading Handler
                Obx(() => controller.isLoading.value
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      )
                    : GradientButton(
                        label: 'Simpan & Buat Undangan',
                        onTap: controller.saveEvent,
                        icon: Icons.arrow_forward_rounded,
                      )),
                const SizedBox(height: 32),

                // Aksi Kelola Acara (Otomatis bertahan setelah sukses simpan)
                Obx(() {
                  if (controller.currentEvent.value == null) {
                    return const SizedBox.shrink(); 
                  }
                  
                  final activeEventId = controller.currentEvent.value!.id;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kelola Acara', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),
                      Row(children: [
                        Expanded(child: _QuickActionCard(icon: Icons.people_rounded, label: 'Daftar Tamu', color: AppColors.primary, onTap: () => Get.toNamed(AppRoutes.guestList, arguments: activeEventId))),
                        const SizedBox(width: 12),
                        Expanded(child: _QuickActionCard(icon: Icons.qr_code_scanner_rounded, label: 'Scan QR', color: AppColors.secondary, onTap: () => Get.toNamed(AppRoutes.qrScanner))),
                      ]),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(child: _QuickActionCard(icon: Icons.person_add_rounded, label: 'Tambah Tamu', color: AppColors.success, onTap: () => Get.toNamed(AppRoutes.guestRegistration, arguments: activeEventId))),
                        const SizedBox(width: 12),
                        Expanded(child: _QuickActionCard(icon: Icons.dashboard_rounded, label: 'Dasbor', color: AppColors.info, onTap: () => Get.toNamed(AppRoutes.dashboard))),
                      ]),
                    ],
                  );
                }),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FormLabel(label: 'Link Google Maps Lokasi (Opsional)'),
        TextField(
          // 🟢 BISA DIHUBUNGKAN KE CONTROLLER JIKA INGIN DIOPTIMALKAN
          controller: controller.descController,
          decoration: const InputDecoration(
            hintText: 'Paste tautan url share Google Maps di sini',
            prefixIcon: Icon(Icons.map_rounded, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildRekeningInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FormLabel(label: 'Informasi Rekening Bank / Amplop Digital (Opsional)'),
        TextField(
          controller: controller.bankController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: 'Contoh: BCA - 1234567890 a/n Ahmad',
            prefixIcon: Icon(Icons.credit_card_rounded, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildRundownSection(BuildContext context) {
    final timeCtrl = TextEditingController();
    final activityCtrl = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Susunan Acara (Rundown)', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        
        Obx(() => controller.rundownList.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Belum ada agenda susunan acara.', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.rundownList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = controller.rundownList[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.surfaceVariant),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.activity, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              Text(item.time, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                          onPressed: () => controller.removeRundownItem(index),
                        ),
                      ],
                    ),
                  );
                },
              )),
        const SizedBox(height: 4),
        OutlinedButton.icon(
          onPressed: () => _showAddRundownDialog(context, timeCtrl, activityCtrl),
          icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
          label: Text('Tambah Kegiatan', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 46),
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicGallerySection(BuildContext context) {
    bool isWedding = controller.selectedCategory.value == 'wedding';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isWedding ? 'Foto Kedua Mempelai' : 'Foto Anak Khitan', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(isWedding ? 'Pilih 2 foto berturut-turut (Foto ke-1 Pria, Foto ke-2 Wanita)' : 'Pilih 1 foto terbaik anak untuk dipajang di undangan digital', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 12),

        Obx(() {
          if (isWedding) {
            Widget priaWidget = controller.galleryFiles.isNotEmpty
                ? _buildIndividualPhotoPreview(controller.galleryFiles[0].path, 'Mempelai Pria', () => controller.removeGalleryFile(0))
                : _buildEmptyPhotoPlaceholder('Pilih Foto Pria', () => controller.pickGalleryImage());

            Widget wanitaWidget = controller.galleryFiles.length >= 2
                ? _buildIndividualPhotoPreview(controller.galleryFiles[1].path, 'Mempelai Wanita', () => controller.removeGalleryFile(1))
                : _buildEmptyPhotoPlaceholder('Pilih Foto Wanita', () => controller.pickGalleryImage());

            return Row(
              children: [
                Expanded(child: priaWidget),
                const SizedBox(width: 14),
                Expanded(child: wanitaWidget),
              ],
            );
          } else {
            return controller.galleryFiles.isNotEmpty
                ? _buildIndividualPhotoPreview(controller.galleryFiles[0].path, 'Foto Anak', () => controller.removeGalleryFile(0))
                : _buildEmptyPhotoPlaceholder('Ambil / Pilih Foto Anak Khitan', () => controller.pickGalleryImage());
          }
        }),
        
        const SizedBox(height: 14),
        Obx(() {
          int limitFoto = isWedding ? 2 : 1;
          return controller.galleryFiles.length < limitFoto 
            ? OutlinedButton.icon(
                onPressed: () => controller.pickGalleryImage(), 
                icon: const Icon(Icons.add_photo_alternate_rounded, size: 18),
                label: Text(isWedding ? (controller.galleryFiles.isEmpty ? 'Pilih Foto Pengantin' : 'Pilih Foto Wanita') : 'Pilih Foto Anak', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 46),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              )
            : const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildIndividualPhotoPreview(String path, String label, VoidCallback onRemove) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(File(path), width: double.infinity, height: 140, fit: BoxFit.cover),
            ),
            Positioned(
              top: 6, right: 6,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 6),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildEmptyPhotoPlaceholder(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.textHint.withOpacity(0.3), style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt_rounded, color: AppColors.textSecondary, size: 24),
            const SizedBox(height: 6),
            Text(text, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  void _showAddRundownDialog(BuildContext context, TextEditingController time, TextEditingController act) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Agenda Kegiatan Baru', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: time, decoration: const InputDecoration(hintText: 'Jam (Contoh: 09:00 - selesai)')),
            const SizedBox(height: 10),
            TextField(controller: act, decoration: const InputDecoration(hintText: 'Nama Kegiatan (Contoh: Resepsi)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal', style: GoogleFonts.poppins(color: AppColors.textSecondary))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              if (time.text.isNotEmpty && act.text.isNotEmpty) {
                controller.addRundownItem(time.text.trim(), act.text.trim());
                time.clear(); act.clear();
                Get.back();
              }
            },
            child: Text('Simpan', style: GoogleFonts.poppins(color: Colors.white)),
          )
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
        padding: const EdgeInsets.only(bottom: 6, top: 4),
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