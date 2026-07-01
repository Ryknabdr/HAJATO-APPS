import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        
        // --- IMPLEMENTASI REFRESH INDICATOR ---
        return RefreshIndicator(
          color: AppColors.primary, // Warna loading spinner
          backgroundColor: Colors.white,
          edgeOffset: 100, // Menyesuaikan offset agar loading muncul proporsional di sliver bar
          onRefresh: () async {
            // Memanggil kembali fungsi fetchProfile untuk menyegarkan data
            await controller.fetchProfile();
          },
          child: CustomScrollView(
            // Wajib ditambahkan AlwaysScrollableScrollPhysics agar layar sliver bisa ditarik ke bawah
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context), // Oper context ke sliver app bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVendorBanner(),
                      const SizedBox(height: 24),
                      _sectionLabel('Akun'),
                      _buildMenuCard([
                        _MenuItem(
                          icon: Icons.person_outline_rounded,
                          label: 'Edit Profil',
                          onTap: () => Get.toNamed('/profile/edit'),
                        ),
                        _MenuItem(
                          icon: Icons.lock_outline_rounded,
                          label: 'Ubah Password',
                          onTap: () {
                            Get.toNamed(AppRoutes.changePassword);
                          },
                        ),
                        _MenuItem(
                          icon: Icons.receipt_long_rounded,
                          label: 'Pesanan Saya',
                          onTap: () => Get.toNamed('/my-bookings'),
                        ),
                        _MenuItem(
                          icon: Icons.history_rounded,
                          label: 'Aktivitas Saya',
                          onTap: () => Get.toNamed('/activity-log'),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _sectionLabel('Lainnya'),
                      _buildMenuCard([
                        _MenuItem(
                          icon: Icons.help_outline_rounded,
                          label: 'Pusat Bantuan',
                          onTap: () => Get.toNamed('/profile/help'),
                        ),
                        _MenuItem(
                          icon: Icons.privacy_tip_outlined,
                          label: 'Kebijakan Privasi',
                          onTap: () => Get.toNamed('/profile/privacy'),
                        ),
                        _MenuItem(
                          icon: Icons.description_outlined,
                          label: 'Syarat & Ketentuan',
                          onTap: () => Get.toNamed('/profile/terms'),
                        ),
                        _MenuItem(
                          icon: Icons.info_outline_rounded,
                          label: 'Tentang Aplikasi',
                          subtitle: 'v1.0.0',
                          onTap: () => Get.toNamed('/profile/about'),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _sectionLabel('Zona Berbahaya'),
                      _buildMenuCard([
                        _MenuItem(
                          icon: Icons.logout_rounded,
                          label: 'Keluar',
                          color: AppColors.primary,
                          onTap: controller.logout,
                        ),
                        _MenuItem(
                          icon: Icons.delete_forever_outlined,
                          label: 'Hapus Akun',
                          color: AppColors.error,
                          onTap: controller.deleteAccount,
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildVendorBanner() {
    return GestureDetector(
      onTap: () => Get.toNamed('/vendor-registration'),
      child: Container(
        padding: const EdgeInsets.all(16),
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
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.storefront_rounded,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftarkan Bisnis Anda',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Jangkau ribuan pelanggan hajatan',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white, size: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
            ),
            CustomPaint(painter: _GridPainter()),
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    // ── 🟢 UPDATE TOTAL: GESTURE DETECTOR ALA WHATSAPP (PREVIEW ATAS + KLIK FULL SCREEN) ──
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            // 🟢 Ngatur posisi pop-up agar gantung di ATAS ala WA
                            alignment: const Alignment(0, -0.4), 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              width: 250,
                              height: 310,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  // # Area Atas: Foto Profil Preview
                                  Expanded(
                                    child: GestureDetector(
                                      // 🟢 KLIK KEDUA - Buka Full Screen utuh pas foto diklik lagi
                                      onTap: () {
                                        Navigator.pop(context); // Tutup dulu dialog kecilnya
                                        Get.to(() => Scaffold(
                                          backgroundColor: Colors.black,
                                          appBar: AppBar(
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                            title: Text(controller.name.value, style: GoogleFonts.dmSans()),
                                            elevation: 0,
                                          ),
                                          body: Center(
                                            child: Obx(() => controller.avatarUrl.value.isNotEmpty
                                                ? Image.network(
                                                    controller.avatarUrl.value,
                                                    fit: BoxFit.contain,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  )
                                                : Container(
                                                    color: AppColors.primary.withOpacity(0.2),
                                                    child: Center(
                                                      child: Text(
                                                        controller.name.value.isNotEmpty ? controller.name.value[0].toUpperCase() : '?',
                                                        style: GoogleFonts.playfairDisplay(fontSize: 120, fontWeight: FontWeight.w700, color: Colors.white),
                                                      ),
                                                    ),
                                                  )),
                                          ),
                                        ));
                                      },
                                      child: Obx(() => Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.15),
                                          image: controller.avatarUrl.value.isNotEmpty
                                              ? DecorationImage(
                                                  image: NetworkImage(controller.avatarUrl.value),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: controller.avatarUrl.value.isEmpty
                                            ? Center(
                                                child: Text(
                                                  controller.name.value.isNotEmpty ? controller.name.value[0].toUpperCase() : '?',
                                                  style: GoogleFonts.playfairDisplay(
                                                    fontSize: 80,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      )),
                                    ),
                                  ),
                                  
                                  // # Area Bawah: Nama & Email di dalam Pop-up
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Obx(() => Text(
                                          controller.name.value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                        )),
                                        const SizedBox(height: 2),
                                        Obx(() => Text(
                                          controller.email.value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSecondary),
                                        )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Obx(
                        () => Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                            image: controller.avatarUrl.value.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(
                                      controller.avatarUrl.value,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: controller.avatarUrl.value.isEmpty
                              ? Center(
                                  child: Text(
                                    controller.name.value.isNotEmpty
                                        ? controller.name.value[0].toUpperCase()
                                        : '?',
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Text(
                          controller.name.value,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        )),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          controller.email.value,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        )),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          controller.bio.value,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      title: Text('Profil Saya',
          style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600, color: Colors.white)),
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 10),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      );

  Widget _buildMenuCard(List<_MenuItem> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2DFDB), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (item.color ?? AppColors.primary).withOpacity(0.1),
                  ),
                  child: Icon(item.icon,
                      color: item.color ?? AppColors.primary, size: 18),
                ),
                title: Text(
                  item.label,
                  style: GoogleFonts.dmSans(
                    color: item.color ?? AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                subtitle: item.subtitle != null
                    ? Text(
                        item.subtitle!,
                        style: GoogleFonts.dmSans(
                            color: AppColors.textSecondary, fontSize: 12),
                      )
                    : null,
                trailing: Icon(Icons.chevron_right_rounded,
                    color: AppColors.textHint, size: 20),
                onTap: item.onTap,
              ),
              if (!isLast)
                Divider(height: 1, indent: 68, color: const Color(0xFFB2DFDB)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color? color;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.color,
    required this.onTap,
  });
}