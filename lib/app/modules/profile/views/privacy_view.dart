import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kOrange     = Color(0xFFFF6B2C);
const _kOrangeDark = Color(0xFFD94F10);
const _kBg         = Color(0xFFFFF8F5);
const _kTextDark   = Color(0xFF18130A);
const _kTextLight  = Color(0xFF8A8278);
const _kBorder     = Color(0xFFEDE9E1);

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Kebijakan Privasi',
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(
              icon: Icons.privacy_tip_outlined,
              title: 'Kebijakan Privasi',
              lastUpdated: '1 Januari 2025',
            ),
            const SizedBox(height: 20),
            _sectionTile('1. Informasi yang Kami Kumpulkan',
                'Kami mengumpulkan informasi yang Anda berikan secara langsung, seperti nama, alamat email, nomor telepon, dan informasi pembayaran saat Anda mendaftar atau menggunakan layanan kami.'),
            _sectionTile('2. Penggunaan Informasi',
                'Informasi yang dikumpulkan digunakan untuk menyediakan, memelihara, dan meningkatkan layanan kami, memproses transaksi, mengirimkan notifikasi terkait layanan, serta merespons pertanyaan dan permintaan Anda.'),
            _sectionTile('3. Berbagi Informasi',
                'Kami tidak menjual, memperdagangkan, atau mengalihkan informasi pribadi Anda kepada pihak ketiga tanpa persetujuan Anda, kecuali untuk vendor yang membantu menjalankan platform kami.'),
            _sectionTile('4. Keamanan Data',
                'Kami menggunakan enkripsi SSL 256-bit dan langkah-langkah keamanan industri untuk melindungi informasi pribadi Anda dari akses yang tidak sah.'),
            _sectionTile('5. Hak Pengguna',
                'Anda berhak mengakses, memperbarui, atau menghapus informasi pribadi Anda kapan saja melalui pengaturan akun atau dengan menghubungi tim support kami.'),
          ],
        ),
      ),
    );
  }
}

Widget _headerCard({required IconData icon, required String title, required String lastUpdated}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFFF8C42), _kOrangeDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.2),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(height: 2),
              Text('Terakhir diperbarui: $lastUpdated',
                  style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.75))),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _sectionTile(String title, String body) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: _kBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _kTextDark)),
        const SizedBox(height: 8),
        Text(body,
            style: GoogleFonts.dmSans(
                fontSize: 13, color: _kTextLight, height: 1.6)),
      ],
    ),
  );
}