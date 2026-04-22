import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/event_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class InvitationView extends GetView<EventController> {
  const InvitationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HajatAppBar(title: 'Undangan Digital'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Preview card
            _buildInvitationPreview(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Link sharing
                  _buildLinkSection(),
                  const SizedBox(height: 20),
                  // Share buttons
                  _buildShareButtons(),
                  const SizedBox(height: 20),
                  // Options
                  _buildOptions(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvitationPreview() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          Positioned(top: -20, right: -20,
            child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)))),
          Positioned(bottom: -30, left: -20,
            child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const Icon(Icons.favorite_rounded, color: Colors.white, size: 36),
                const SizedBox(height: 12),
                Text('Undangan', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, letterSpacing: 2)),
                const SizedBox(height: 4),
                Obx(() => Text(
                  controller.currentEvent.value?.namaAcara ?? 'Nama Acara',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white24,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(() => _InviteDetail(
                      icon: Icons.calendar_month_rounded,
                      label: 'Tanggal',
                      value: controller.formattedDate,
                    )),
                    Container(width: 1, height: 40, color: Colors.white24),
                    Obx(() => _InviteDetail(
                      icon: Icons.location_on_rounded,
                      label: 'Lokasi',
                      value: controller.currentEvent.value?.lokasi ?? '-',
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Link Undangan', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Obx(() => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      controller.invitationLink.value,
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: controller.invitationLink.value));
                      Get.snackbar('Disalin!', 'Link undangan berhasil disalin',
                          snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.success, colorText: Colors.white);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                      child: Text('Salin', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

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
        Text('Bagikan Via', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: platforms.map((p) {
            final color = p['color'] as Color;
            return GestureDetector(
              onTap: () => Get.snackbar('Berbagi', 'Membuka ${p['label']}...', snackPosition: SnackPosition.BOTTOM),
              child: Column(children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                  child: Icon(p['icon'] as IconData, color: color, size: 26),
                ),
                const SizedBox(height: 6),
                Text(p['label'] as String, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
              ]),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return Column(
      children: [
        GradientButton(
          label: 'Bagikan Undangan',
          onTap: () => Get.snackbar('Berbagi', 'Membuka opsi berbagi...', snackPosition: SnackPosition.BOTTOM),
          icon: Icons.share_rounded,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => Get.toNamed('/guest-registration'),
          icon: const Icon(Icons.person_add_rounded),
          label: const Text('Daftarkan Tamu Manual'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}

class _InviteDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InviteDetail({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, color: Colors.white70, size: 18),
      const SizedBox(height: 4),
      Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10)),
      const SizedBox(height: 2),
      Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          maxLines: 1, overflow: TextOverflow.ellipsis),
    ]);
  }
}
