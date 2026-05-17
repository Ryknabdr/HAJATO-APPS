import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  static const _faqs = [
    _FAQ(q: 'Bagaimana cara memesan vendor?', a: 'Pilih vendor dari daftar, klik "Pesan Sekarang", lalu isi detail acara dan lakukan pembayaran.'),
    _FAQ(q: 'Apakah bisa membatalkan pesanan?', a: 'Pembatalan dapat dilakukan maksimal 3 hari sebelum tanggal acara. Biaya pembatalan dapat berlaku sesuai kebijakan vendor.'),
    _FAQ(q: 'Bagaimana cara menghubungi vendor?', a: 'Gunakan fitur Chat di halaman detail vendor atau pada halaman detail pesanan Anda.'),
    _FAQ(q: 'Metode pembayaran apa saja yang tersedia?', a: 'Kami mendukung transfer bank, QRIS, kartu kredit/debit, dan dompet digital (GoPay, OVO, DANA).'),
    _FAQ(q: 'Bagaimana jika ada masalah pada hari acara?', a: 'Hubungi tim support kami melalui tombol "Bantuan Darurat" di halaman pesanan aktif.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Pusat Bantuan',
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFB2DFDB)),
              ),
              child: TextField(
                style: GoogleFonts.dmSans(
                    fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Cari pertanyaan...',
                  hintStyle: GoogleFonts.dmSans(
                      fontSize: 14, color: AppColors.textHint),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: AppColors.primary.withOpacity(0.6), size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Contact banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Butuh bantuan lebih?',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('Tim kami siap membantu 24/7',
                            style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8))),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    child: Text('Hubungi',
                        style: GoogleFonts.dmSans(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text('PERTANYAAN UMUM',
                  style: GoogleFonts.dmSans(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8)),
            ),

            ..._faqs.map((faq) => _FaqTile(faq: faq)),
          ],
        ),
      ),
    );
  }
}

class _FAQ {
  final String q;
  final String a;
  const _FAQ({required this.q, required this.a});
}

class _FaqTile extends StatefulWidget {
  final _FAQ faq;
  const _FaqTile({required this.faq});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
            color: _open
                ? AppColors.primary.withOpacity(0.4)
                : const Color(0xFFB2DFDB)),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            title: Text(widget.faq.q,
                style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary)),
            trailing: AnimatedRotation(
              turns: _open ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary, size: 22),
            ),
            onTap: () => setState(() => _open = !_open),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _open
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(widget.faq.a,
                        style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.6)),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}