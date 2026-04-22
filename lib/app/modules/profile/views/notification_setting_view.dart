import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';

const _kOrange   = Color(0xFFFF6B2C);
const _kBg       = Color(0xFFFFF8F5);
const _kTextDark = Color(0xFF18130A);
const _kTextLight = Color(0xFF8A8278);
const _kBorder   = Color(0xFFEDE9E1);

class NotificationSettingView extends GetView<ProfileController> {
  const NotificationSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kOrange,
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
                      color: _kTextLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8)),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _kBorder),
                boxShadow: [
                  BoxShadow(
                      color: _kOrange.withOpacity(0.06),
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
                  Divider(height: 1, indent: 68, color: _kBorder),
                  Obx(() => _buildToggle(
                        'Booking & Pesanan',
                        'Status pemesanan kamu',
                        Icons.calendar_today_outlined,
                        controller.notifBooking.value,
                        (v) => controller.notifBooking.value = v,
                      )),
                  Divider(height: 1, indent: 68, color: _kBorder),
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
          color: _kOrange.withOpacity(0.1),
        ),
        child: Icon(icon, color: _kOrange, size: 18),
      ),
      title: Text(title,
          style: GoogleFonts.dmSans(
              color: _kTextDark, fontWeight: FontWeight.w500, fontSize: 14)),
      subtitle: Text(subtitle,
          style: GoogleFonts.dmSans(color: _kTextLight, fontSize: 12)),
      trailing: Switch(
          value: value, onChanged: onChanged, activeColor: _kOrange),
    );
  }
}