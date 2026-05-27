import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/vendor_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../data/models/models.dart';

class VendorListView extends GetView<VendorController> {
  const VendorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HajatAppBar(
        title: 'Daftar Vendor',
        actions: [
          Obx(() => IconButton(
                icon: Icon(controller.isGridView.value ? Icons.view_list_rounded : Icons.grid_view_rounded),
                onPressed: controller.toggleView,
              )),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildSearch(),
              _buildCategories(),
              _buildFilterBar(),
              Expanded(child: _buildVendorList()),
            ],
          ),
          
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        onChanged: controller.onSearch,
        decoration: InputDecoration(
          hintText: 'Cari vendor...',
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = controller.categories[i];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == cat;
            return GestureDetector(
              onTap: () => controller.selectCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : AppColors.textHint.withOpacity(0.3),
                  ),
                ),
                child: Text(cat,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textSecondary)),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Obx(() => Text('${controller.filteredVendors.length} vendor ditemukan',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary))),
          const Spacer(),
          PopupMenuButton<String>(
            onSelected: controller.setSortBy,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.textHint.withOpacity(0.3))),
              child: Row(children: [
                const Icon(Icons.sort_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('Urutkan', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              ]),
            ),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'rating', child: Text('Rating Tertinggi', style: GoogleFonts.poppins(fontSize: 13))),
              PopupMenuItem(value: 'price_asc', child: Text('Harga Terendah', style: GoogleFonts.poppins(fontSize: 13))),
              PopupMenuItem(value: 'price_desc', child: Text('Harga Tertinggi', style: GoogleFonts.poppins(fontSize: 13))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVendorList() {
    return Obx(() {
      if (controller.filteredVendors.isEmpty) {
        return const EmptyState(
          icon: Icons.store_rounded,
          title: 'Vendor Tidak Ditemukan',
          subtitle: 'Coba ubah filter atau kata kunci pencarian Anda',
        );
      }
      return controller.isGridView.value
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: controller.filteredVendors.length,
              itemBuilder: (_, i) => _VendorGridCard(
                vendor: controller.filteredVendors[i],
                onTap: () => controller.goToDetail(controller.filteredVendors[i]),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.filteredVendors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _VendorListCard(
                vendor: controller.filteredVendors[i],
                onTap: () => controller.goToDetail(controller.filteredVendors[i]),
              ),
            );
    });
  }
}

class _VendorListCard extends StatelessWidget {
  final VendorModel vendor;
  final VoidCallback onTap;
  const _VendorListCard({required this.vendor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(vendor.imageUrl, width: 100, height: 100, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 100, height: 100, color: AppColors.surfaceVariant,
                      child: const Icon(Icons.image_rounded, color: AppColors.textHint))),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vendor.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(vendor.category, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.star_rounded, color: AppColors.warning, size: 14),
                      const SizedBox(width: 2),
                      Text('${vendor.rating} (${vendor.reviewCount})',
                          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                    ]),
                    const SizedBox(height: 4),
                    Text('Mulai ${formatRupiah(vendor.startingPrice)}',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorGridCard extends StatelessWidget {
  final VendorModel vendor;
  final VoidCallback onTap;
  const _VendorGridCard({required this.vendor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(vendor.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 120, color: AppColors.surfaceVariant,
                      child: const Icon(Icons.image_rounded, color: AppColors.textHint))),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendor.name, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(vendor.category, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.star_rounded, color: AppColors.warning, size: 12),
                    const SizedBox(width: 2),
                    Text('${vendor.rating}', style: GoogleFonts.poppins(fontSize: 11)),
                  ]),
                  const SizedBox(height: 2),
                  Text(formatRupiah(vendor.startingPrice),
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}