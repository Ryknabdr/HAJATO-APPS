import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/promo_controller.dart';

class PromoView extends GetView<PromoController> {
  const PromoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                );
              }
              if (controller.filteredPromos.isEmpty) {
                return _buildEmpty();
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                itemCount: controller.filteredPromos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final promo = controller.filteredPromos[i];
                  return _PromoCard(
                    promo: promo,
                    onClaim: () => controller.claimPromo(promo),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── HEADER ───────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Promo & Penawaran',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              Text(
                'Hemat lebih banyak untuk hajatanmu',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── TABS ─────────────────────────────────────────────────
  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: controller.categories.map((cat) {
                    final isSelected =
                        controller.selectedCategory.value == cat;
                    return GestureDetector(
                      onTap: () => controller.filterByCategory(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
        ],
      ),
    );
  }

  // ── EMPTY ─────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_offer_outlined,
              size: 48, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(
            'Belum ada promo',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Promo kategori ini belum tersedia',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PROMO CARD
// ─────────────────────────────────────────────────────────────

class _PromoCard extends StatelessWidget {
  final PromoModel promo;
  final VoidCallback onClaim;
  const _PromoCard({required this.promo, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(),
          _buildTicketDivider(),
          _buildBottom(),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: promo.color.withOpacity(0.08),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon kategori
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: promo.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(promo.icon, color: promo.color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (promo.isNew)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'BARU',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                Text(
                  promo.title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  promo.subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Diskon badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: promo.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  promo.discount,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                Text(
                  'OFF',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDivider() {
    return Row(
      children: [
        Container(
          width: 12,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius:
                BorderRadius.horizontal(right: Radius.circular(12)),
            border: Border(
              top: BorderSide(color: Color(0xFFEEEEEE)),
              right: BorderSide(color: Color(0xFFEEEEEE)),
              bottom: BorderSide(color: Color(0xFFEEEEEE)),
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(builder: (_, c) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                (c.maxWidth / 10).floor(),
                (_) => Container(
                  width: 5,
                  height: 1,
                  color: const Color(0xFFDDDDDD),
                ),
              ),
            );
          }),
        ),
        Container(
          width: 12,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius:
                BorderRadius.horizontal(left: Radius.circular(12)),
            border: Border(
              top: BorderSide(color: Color(0xFFEEEEEE)),
              left: BorderSide(color: Color(0xFFEEEEEE)),
              bottom: BorderSide(color: Color(0xFFEEEEEE)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(promo.icon, color: promo.color, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      promo.category,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: promo.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 12, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      'Berlaku s/d ${promo.validUntil}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClaim,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Klaim Promo',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}