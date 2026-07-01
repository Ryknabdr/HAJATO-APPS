import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/event_controller.dart';
import '../../../routes/app_routes.dart'; // Menghubungkan rute sah proyek HAJATO kamu

class AppColors {
  static const Color primary = Color(0xFF4F6AF5);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
}

class InvitationView extends GetView<EventController> {
  const InvitationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'Undangan Digital',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildCardPreview(),
            const SizedBox(height: 24),
            _buildLinkBox(),
            const SizedBox(height: 28),
            _buildShareButtons(),
            const SizedBox(height: 32),
            _buildOptions(),
          ],
        ),
      ),
    );
  }

  // ── 🟢 FIX TOTAL: KARTU PREVIEW FLUTTER SEKARANG BERUBAH SESUAI KATEGORI ACARA ──
  Widget _buildCardPreview() {
    return Obx(() {
      final event = controller.currentEvent.value;
      final kategori = controller.selectedCategory.value; // Membaca kategori dinamis dari form sebelah

      // Inisialisasi variabel default (untuk Pernikahan/Wedding)
      String emojiHeader = '💍';
      String labelKategori = 'UNDANGAN PERNIKAHAN';
      Color aksenWarna = const Color(0xFFC9A96E); // Gold mewah khas wedding

      // Percabangan penyesuaian UI berdasarkan jenis kategori
      if (kategori == 'khitanan') {
        emojiHeader = '👦';
        labelKategori = 'TASYAKURAN KHITANAN';
        aksenWarna = const Color(0xFF10B981); // Hijau segar khas syukuran
      } else if (kategori == 'formal') {
        emojiHeader = '🏢';
        labelKategori = 'E-INVITATION FORMAL EVENT';
        aksenWarna = AppColors.primary; // Biru profesional formal
      }

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              emojiHeader,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 12),
            Text(
              labelKategori,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: aksenWarna, // Warna dinamis sesuai jenis acara
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event?.namaAcara ?? 'Nama Acara',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const Divider(height: 32, thickness: 1, color: AppColors.border),
            Row(
              children: [
                Icon(Icons.calendar_month_rounded, color: aksenWarna, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.formattedDate,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_rounded, color: aksenWarna, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    event?.lokasi ?? 'Lokasi Belum Ditentukan',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ── KOTAK LINK UNDANGAN UTK COPY ───────────────────────────────────────────
  Widget _buildLinkBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.link_rounded, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => Text(
                  controller.invitationLink.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                )),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.copy_rounded, color: AppColors.primary, size: 20),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: controller.invitationLink.value));
              Get.snackbar(
                'Sukses',
                'Tautan undangan berhasil disalin!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── GRID TOMBOL BAGIKAN MEDIA SOSIAL ───────────────────────────────────────
  Widget _buildShareButtons() {
    final platforms = [
      {'label': 'WhatsApp', 'icon': Icons.chat_rounded, 'color': const Color(0xFF25D366)},
      {'label': 'Instagram', 'icon': Icons.camera_alt_rounded, 'color': const Color(0xFFE1306C)},
      {'label': 'Email', 'icon': Icons.email_rounded, 'color': const Color(0xFF4F6AF5)},
      {'label': 'Lainnya', 'icon': Icons.share_rounded, 'color': AppColors.textSecondary},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bagikan Via',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: platforms.map((p) {
            final color = p['color'] as Color;
            final label = p['label'] as String;
            return GestureDetector(
              onTap: () => controller.shareToPlatform(label),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(p['icon'] as IconData, color: color, size: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── ACTIONS TOMBOL UTAMA ───────────────────────────────────────────────────
  Widget _buildOptions() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => controller.shareToPlatform('Lainnya'),
          icon: const Icon(Icons.share_rounded, size: 18),
          label: Text('Bagikan Undangan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            String fullLink = controller.invitationLink.value;
            if (fullLink.isNotEmpty) {
              String extractedId = fullLink.split('/').last;
              print("[DEBUG HAJATO] BYPASS EXTRACTED ID FROM LINK: $extractedId");
              
              Get.toNamed(
                AppRoutes.guestRegistration,
                arguments: extractedId,
              );
            } else {
              Get.snackbar(
                'Peringatan', 
                'Data tautan undangan belum siap atau kosong.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFFFBBF24),
              );
            }
          },
          icon: const Icon(Icons.person_add_rounded, size: 18, color: AppColors.primary),
          label: Text(
            'Daftarkan Tamu Manual',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}