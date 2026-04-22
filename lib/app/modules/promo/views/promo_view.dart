import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/promo_controller.dart';

class PromoView extends GetView<PromoController> {
  const PromoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2EE),
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryFilter(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                );
              }
              if (controller.filteredPromos.isEmpty) {
                return _buildEmpty();
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1108), Color(0xFF2D1F00)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD4AF37).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white70, size: 18),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Promo & Penawaran',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Hemat lebih banyak untuk hajatanmu',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 36,
        child: Obx(() => ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = controller.categories[i];
                final isSelected = controller.selectedCategory.value == cat;
                return GestureDetector(
                  onTap: () => controller.filterByCategory(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isSelected
                          ? const Color(0xFF1A1108)
                          : const Color(0xFFF5F0E8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFD4AF37)
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFF8A8278),
                      ),
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0E8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.local_offer_outlined,
                color: Color(0xFFD4AF37), size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada promo',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF18130A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Promo untuk kategori ini\nbelum tersedia saat ini',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: const Color(0xFF8A8278),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PROMO CARD ───────────────────────────────────────────────────────────────

class _PromoCard extends StatelessWidget {
  final PromoModel promo;
  final VoidCallback onClaim;
  const _PromoCard({required this.promo, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Banner atas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A1108),
                  promo.color.withOpacity(0.8),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (promo.isNew)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'BARU',
                            style: GoogleFonts.dmSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      Text(
                        promo.title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promo.subtitle,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Discount badge
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        promo.discount,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                      Text(
                        'OFF',
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Garis putus-putus
          Row(
            children: [
              _SemiCircle(isLeft: true),
              Expanded(
                child: LayoutBuilder(builder: (_, c) {
                  return Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      (c.maxWidth / 8).floor(),
                      (_) => Container(
                        width: 4,
                        height: 1,
                        color: const Color(0xFFEDE9E1),
                      ),
                    ),
                  );
                }),
              ),
              _SemiCircle(isLeft: false),
            ],
          ),

          // ── Bagian bawah
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(promo.icon, color: promo.color, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          promo.category,
                          style: GoogleFonts.dmSans(
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
                        const Icon(Icons.access_time_rounded,
                            color: Color(0xFFB5B0A8), size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'Berlaku s/d ${promo.validUntil}',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: const Color(0xFF8A8278),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onClaim,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD4AF37), Color(0xFFA07800)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFA07800).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'Klaim',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SemiCircle extends StatelessWidget {
  final bool isLeft;
  const _SemiCircle({required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        widthFactor: 0.5,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F2EE),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFEDE9E1)),
          ),
        ),
      ),
    );
  }
}