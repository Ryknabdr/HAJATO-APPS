import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';

// ─── Privacy View ─────────────────────────────────────────────────────────────

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Kebijakan Privasi',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
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
            _sectionTile(
              '1. Informasi yang Kami Kumpulkan',
              'Kami mengumpulkan informasi yang Anda berikan secara langsung, seperti nama, alamat email, nomor telepon, dan informasi pembayaran saat Anda mendaftar atau menggunakan layanan kami.',
            ),
            _sectionTile(
              '2. Penggunaan Informasi',
              'Informasi yang dikumpulkan digunakan untuk menyediakan, memelihara, dan meningkatkan layanan kami, memproses transaksi, mengirimkan notifikasi terkait layanan, serta merespons pertanyaan dan permintaan Anda.',
            ),
            _sectionTile(
              '3. Berbagi Informasi',
              'Kami tidak menjual, memperdagangkan, atau mengalihkan informasi pribadi Anda kepada pihak ketiga tanpa persetujuan Anda, kecuali untuk vendor yang membantu menjalankan platform kami.',
            ),
            _sectionTile(
              '4. Keamanan Data',
              'Kami menggunakan sistem keamanan untuk melindungi informasi pribadi Anda dari akses yang tidak sah, penyalahgunaan, perubahan, atau penghapusan data.',
            ),
            _sectionTile(
              '5. Hak Pengguna',
              'Anda berhak mengakses, memperbarui, atau menghapus informasi pribadi Anda kapan saja melalui pengaturan akun atau dengan menghubungi tim support kami.',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Terms View ───────────────────────────────────────────────────────────────

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Syarat & Ketentuan',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(
              icon: Icons.description_outlined,
              title: 'Syarat & Ketentuan',
              lastUpdated: '1 Januari 2025',
            ),
            const SizedBox(height: 20),
            _sectionTile(
              '1. Penerimaan Syarat',
              'Dengan menggunakan aplikasi HAJATO, Anda menyetujui syarat dan ketentuan ini. Jika Anda tidak setuju, harap hentikan penggunaan aplikasi.',
            ),
            _sectionTile(
              '2. Penggunaan Layanan',
              'Layanan HAJATO hanya dapat digunakan untuk tujuan yang sah. Anda bertanggung jawab atas semua aktivitas yang terjadi melalui akun Anda.',
            ),
            _sectionTile(
              '3. Pemesanan & Pembayaran',
              'Semua pemesanan vendor bersifat mengikat setelah pembayaran dikonfirmasi. Harga yang ditampilkan mengikuti informasi layanan yang tersedia di aplikasi.',
            ),
            _sectionTile(
              '4. Pembatalan & Pengembalian Dana',
              'Pembatalan dapat dilakukan sesuai kebijakan yang berlaku. Pengembalian dana akan diproses berdasarkan status pesanan dan ketentuan layanan.',
            ),
            _sectionTile(
              '5. Tanggung Jawab',
              'HAJATO bertindak sebagai platform perantara antara pengguna dan vendor. Vendor bertanggung jawab atas layanan yang ditawarkan kepada pengguna.',
            ),
            _sectionTile(
              '6. Perubahan Syarat',
              'HAJATO berhak mengubah syarat dan ketentuan ini kapan saja. Perubahan dapat diberitahukan melalui aplikasi, email, atau notifikasi.',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Helpers ───────────────────────────────────────────────────────────

Widget _headerCard({
  required IconData icon,
  required String title,
  required String lastUpdated,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: AppColors.primaryGradient,
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
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Terakhir diperbarui: $lastUpdated',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
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
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(
        color: const Color(0xFFB2DFDB),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    ),
  );
}