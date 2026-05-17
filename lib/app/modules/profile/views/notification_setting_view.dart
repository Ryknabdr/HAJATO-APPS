import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';
import '../../../core/theme/app_theme.dart'; // sesuaikan path-nya

class NotificationSettingView extends GetView<ProfileController> {
  const NotificationSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Pengaturan Notifikasi',
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text('NOTIFIKASI',
                  style: GoogleFonts.dmSans(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8)),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFB2DFDB)),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Obx(() => _buildToggle(
                        'Promo & Penawaran',
                        'Dapatkan info promo terbaru',
                        Icons.local_offer_outlined,
                        controller.notifPromo.value,
                        (v) => controller.notifPromo.value = v,
                      )),
                  Divider(height: 1, indent: 68, color: const Color(0xFFB2DFDB)),
                  Obx(() => _buildToggle(
                        'Booking & Pesanan',
                        'Status pemesanan kamu',
                        Icons.calendar_today_outlined,
                        controller.notifBooking.value,
                        (v) => controller.notifBooking.value = v,
                      )),
                  Divider(height: 1, indent: 68, color: const Color(0xFFB2DFDB)),
                  Obx(() => _buildToggle(
                        'Pesan & Chat',
                        'Notifikasi pesan masuk',
                        Icons.chat_bubble_outline_rounded,
                        controller.notifChat.value,
                        (v) => controller.notifChat.value = v,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(String title, String subtitle, IconData icon,
      bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primary.withOpacity(0.1),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
      title: Text(title,
          style: GoogleFonts.dmSans(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 14)),
      subtitle: Text(subtitle,
          style: GoogleFonts.dmSans(
              color: AppColors.textSecondary, fontSize: 12)),
      trailing: Switch(
          value: value, onChanged: onChanged, activeColor: AppColors.primary),
    );
  }
}