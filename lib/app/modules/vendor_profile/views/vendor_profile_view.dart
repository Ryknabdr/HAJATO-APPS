import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/vendor_profile_controller.dart';

class VendorProfileView extends GetView<VendorProfileController> {
  const VendorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Profil Vendor',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),

      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // AVATAR
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    controller.vendorName.value.isNotEmpty
                        ? controller.vendorName.value[0]
                            .toUpperCase()
                        : 'V',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                controller.vendorName.value,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                controller.vendorEmail.value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: controller.vendorStatus.value ==
                          'approved'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  controller.vendorStatus.value ==
                          'approved'
                      ? '✓ Vendor Terverifikasi'
                      : '⏳ Menunggu Verifikasi',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color:
                        controller.vendorStatus.value ==
                                'approved'
                            ? Colors.green
                            : Colors.orange,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              _MenuTile(
                icon: Icons.storefront_outlined,
                title: 'Data Vendor',
                onTap: () async {
                  await Get.toNamed(AppRoutes.vendorData);
                  controller.loadVendorData();
                },
              ),
              _MenuTile(
                icon: Icons.history_rounded,
                title: 'Aktivitas Saya',
                onTap: () {
                  Get.toNamed('/activity-log');
                },
              ),

              _MenuTile(
                icon: Icons.lock_outline_rounded,
                title: 'Ubah Password',
                onTap: () {
                  Get.toNamed(AppRoutes.changePassword);
                },
              ),
              _MenuTile(
                icon: Icons.info_outline_rounded,
                title: 'Tentang Aplikasi',
                onTap: () {},
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _MenuTile extends StatelessWidget {

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: ListTile(
        onTap: onTap,

        leading: Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),

        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
        ),
      ),
    );
  }
}