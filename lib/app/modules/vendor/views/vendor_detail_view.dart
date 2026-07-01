import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/vendor_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';

class VendorDetailView extends GetView<VendorController> {
  const VendorDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final vendor = Get.arguments as VendorModel? ?? controller.selectedVendor;
    final pageController = PageController();
    final currentPage = 0.obs;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedVendor = vendor;
      controller.fetchVendorReviews(vendor.id);
      controller.fetchVendorRating(vendor.id);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Image carousel
              SliverToBoxAdapter(child: _buildCarousel(pageController, currentPage)),
              // Basic info
              SliverToBoxAdapter(child: _buildBasicInfo()),
              // Description
              SliverToBoxAdapter(
                child: _buildSection(
                  'Tentang Vendor',
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() => Text(
                          controller.selectedVendor.description,
                          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.7),
                        )),
                  ),
                ),
              ),
              // Packages
              SliverToBoxAdapter(child: _buildSection('Paket Layanan', _buildPackages())),
              // Reviews
              SliverToBoxAdapter(child: _buildSection('Ulasan', _buildReviews())),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          // Top back button
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: Row(children: [
              _topBtn(Icons.share_outlined),
              const SizedBox(width: 8),
              _topBtn(Icons.favorite_border_rounded),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _topBtn(IconData icon) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      );

  Widget _buildCarousel(PageController pc, RxInt page) {
    return Obx(() {
      final activeVendor = controller.selectedVendor;
      final imgs = [activeVendor.imageUrl, ...activeVendor.gallery];
      
      return SizedBox(
        height: 280,
        child: Stack(
          children: [
            PageView.builder(
              controller: pc,
              onPageChanged: (i) => page.value = i,
              itemCount: imgs.length,
              itemBuilder: (_, i) => Image.network(
                imgs[i],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.image_rounded, color: AppColors.textHint, size: 64),
                ),
              ),
            ),
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imgs.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: page.value == i ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: page.value == i ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBasicInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)],
      ),
      child: Obx(() {
        final activeVendor = controller.selectedVendor;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    activeVendor.category,
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ),
                const Spacer(),
                if (activeVendor.isFeatured)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(gradient: AppColors.warmGradient, borderRadius: BorderRadius.circular(8)),
                    child: Text('Unggulan', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(activeVendor.name, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(activeVendor.location, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              const Icon(Icons.star_rounded, color: AppColors.warning, size: 18),
              const SizedBox(width: 3),
              Text(
                controller.detailRating.value.toStringAsFixed(1),
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              Text(
                ' (${controller.detailReviewCount.value} ulasan)',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              _InfoChip(icon: Icons.check_circle_rounded, label: 'Terverifikasi', color: AppColors.success),
              const SizedBox(width: 10),
              _InfoChip(icon: Icons.access_time_rounded, label: 'Respons Cepat', color: AppColors.info),
            ]),
          ],
        );
      }),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Text(title, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700)),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildPackages() {
    return Obx(() {
      final activeVendor = controller.selectedVendor;
      return SizedBox(
        height: 270,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: activeVendor.packages.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final pkg = activeVendor.packages[i];

            return GestureDetector(
              onTap: () => controller.goToBooking(pkg),
              child: Container(
                width: 240,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        pkg.image, 
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 100,
                          width: double.infinity,
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.image_rounded, color: AppColors.textHint, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pkg.name,
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatRupiah(pkg.price),
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.people_rounded, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('${pkg.capacity} orang', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                        const SizedBox(width: 12),
                        const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('${pkg.duration} jam', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      pkg.description,
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildReviews() {
    return Obx(() {
      if (controller.vendorReviews.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Belum ada ulasan', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.vendorReviews.length,
        separatorBuilder: (_, __) => const Divider(height: 20),
        itemBuilder: (_, i) {
          final rev = controller.vendorReviews[i];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  rev.userName.isNotEmpty ? rev.userName[0].toUpperCase() : '?',
                  style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rev.userName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 4),
                    RatingStars(rating: rev.rating, size: 12),
                    const SizedBox(height: 8),
                    Text(rev.comment, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
                    const SizedBox(height: 6),
                    Text(_formatDate(rev.date), style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
              )
            ],
          );
        },
      );
    });
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      const months = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
      return '${date.day} ${months[date.month]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.goToChatVendor,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() {
              final activeVendor = controller.selectedVendor;
              return GradientButton(
                label: 'Pesan Sekarang',
                onTap: () {
                  if (activeVendor.packages.isNotEmpty) {
                    controller.goToBooking(activeVendor.packages.first);
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}