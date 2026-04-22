import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kOrange     = Color(0xFFFF6B2C);
const _kOrangeDark = Color(0xFFD94F10);
const _kOrangeLight = Color(0xFFFF9A5C);
const _kBg         = Color(0xFFFFF8F5);
const _kTextDark   = Color(0xFF18130A);
const _kTextLight  = Color(0xFF8A8278);
const _kBorder     = Color(0xFFEDE9E1);

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Tentang Aplikasi',
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF8C42), _kOrangeDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 1.5),
                    ),
                    child: const Center(
                      child: Text('🎊', style: TextStyle(fontSize: 36)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('HAJATO',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2)),
                  const SizedBox(height: 6),
                  Text('Versi 1.0.0',
                      style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7))),
                  const SizedBox(height: 4),
                  Text('Platform Persiapan Hajatan Terpercaya',
                      style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.85))),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Info card
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
                        _infoRow(Icons.tag_rounded, 'Versi', '1.0.0', false),
                        Divider(height: 1, indent: 68, color: _kBorder),
                        _infoRow(Icons.update_rounded, 'Terakhir Diperbarui', '1 Jan 2025', false),
                        Divider(height: 1, indent: 68, color: _kBorder),
                        _infoRow(Icons.developer_mode_rounded, 'Developer', 'Tim Hajato', false),
                        Divider(height: 1, indent: 68, color: _kBorder),
                        _infoRow(Icons.language_rounded, 'Website', 'www.hajato.id', false),
                        Divider(height: 1, indent: 68, color: _kBorder),
                        _infoRow(Icons.email_outlined, 'Email', 'hello@hajato.id', true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _kBorder),
                    ),
                    child: Text(
                      'Hajato hadir untuk memudahkan persiapan acara hajatan Anda — dari pernikahan, khitanan, hingga syukuran. Temukan vendor terpercaya, kelola tamu, dan buat undangan digital semua dalam satu aplikasi.',
                      style: GoogleFonts.dmSans(
                          fontSize: 13, color: _kTextLight, height: 1.7),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text('© 2025 Hajato. All rights reserved.',
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: _kTextLight)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, bool isLast) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _kOrange.withOpacity(0.1),
        ),
        child: Icon(icon, color: _kOrange, size: 18),
      ),
      title: Text(label,
          style: GoogleFonts.dmSans(
              fontSize: 13, color: _kTextLight, fontWeight: FontWeight.w500)),
      trailing: Text(value,
          style: GoogleFonts.dmSans(
              fontSize: 13, color: _kTextDark, fontWeight: FontWeight.w600)),
    );
  }
}