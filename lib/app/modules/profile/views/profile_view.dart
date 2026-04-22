import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';

const _kOrange     = Color(0xFFFF6B2C);
const _kOrangeDark = Color(0xFFD94F10);
const _kBg         = Color(0xFFFFF8F5);
const _kCard       = Color(0xFFFFFFFF);
const _kTextDark   = Color(0xFF18130A);
const _kTextLight  = Color(0xFF8A8278);
const _kBorder     = Color(0xFFEDE9E1);

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: _kOrange));
        }
        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Akun'),
                    _buildMenuCard([
                      _MenuItem(
                        icon: Icons.person_outline_rounded,
                        label: 'Edit Profil',
                        onTap: () => Get.toNamed('/profile/edit'),
                      ),
                      _MenuItem(
                        icon: Icons.lock_outline_rounded,
                        label: 'Ganti Kata Sandi',
                        onTap: () => Get.toNamed('/profile/change-password'),
                      ),
                      _MenuItem(
                        icon: Icons.notifications_outlined,
                        label: 'Pengaturan Notifikasi',
                        onTap: () => Get.toNamed('/profile/notifications'),
                      ),
                      _MenuItem(
                        icon: Icons.phone_outlined,
                        label: 'Nomor Telepon',
                        subtitle: controller.phone.value,
                        onTap: () => Get.toNamed('/profile/edit'),
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
                        color: _kOrange,
                        onTap: controller.logout,
                      ),
                      _MenuItem(
                        icon: Icons.delete_forever_outlined,
                        label: 'Hapus Akun',
                        color: Colors.red,
                        onTap: controller.deleteAccount,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: _kOrange,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // gradient bg
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF8C42), _kOrangeDark],
                ),
              ),
            ),
            // grid pattern
            CustomPaint(painter: _GridPainter()),
            // orb
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
            // content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Obx(() => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.25),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.5), width: 2),
                        ),
                        child: Center(
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
                        ),
                      )),
                  const SizedBox(height: 12),
                  Obx(() => Text(
                        controller.name.value,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      )),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                        controller.email.value,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      )),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                        controller.bio.value,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      )),
                ],
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
            color: _kTextLight,
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
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: _kOrange.withOpacity(0.06),
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
                    color: (item.color ?? _kOrange).withOpacity(0.1),
                  ),
                  child: Icon(item.icon,
                      color: item.color ?? _kOrange, size: 18),
                ),
                title: Text(
                  item.label,
                  style: GoogleFonts.dmSans(
                    color: item.color ?? _kTextDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                subtitle: item.subtitle != null
                    ? Text(
                        item.subtitle!,
                        style: GoogleFonts.dmSans(
                            color: _kTextLight, fontSize: 12),
                      )
                    : null,
                trailing: Icon(Icons.chevron_right_rounded,
                    color: _kTextLight.withOpacity(0.6), size: 20),
                onTap: item.onTap,
              ),
              if (!isLast)
                Divider(height: 1, indent: 68, color: _kBorder),
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