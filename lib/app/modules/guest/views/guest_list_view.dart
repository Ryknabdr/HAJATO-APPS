import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/guest_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../data/models/models.dart';

class GuestListView extends GetView<GuestController> {
  const GuestListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HajatAppBar(
        title: 'Daftar Tamu',
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded, color: AppColors.primary),
            onPressed: () => Get.toNamed('/guest-registration'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats row
          _buildStats(),
          // Search
          _buildSearch(),
          // Filter chips
          _buildFilterChips(),
          // Guest list
          Expanded(child: _buildGuestList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/qr-scanner'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
        label: Text('Scan QR', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildStats() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(child: _StatItem(value: '${controller.totalGuests}', label: 'Total', color: AppColors.primary)),
              Container(width: 1, height: 40, color: AppColors.surfaceVariant),
              Expanded(child: _StatItem(value: '${controller.hadirCount}', label: 'Hadir', color: AppColors.success)),
              Container(width: 1, height: 40, color: AppColors.surfaceVariant),
              Expanded(child: _StatItem(value: '${controller.checkedInCount}', label: 'Check-in', color: AppColors.info)),
              Container(width: 1, height: 40, color: AppColors.surfaceVariant),
              Expanded(child: _StatItem(
                value: '${controller.totalGuests - controller.hadirCount}',
                label: 'Tidak Hadir',
                color: AppColors.error,
              )),
            ],
          ),
        ));
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (v) => controller.searchQuery.value = v,
        decoration: const InputDecoration(
          hintText: 'Cari nama tamu...',
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Semua', 'Hadir', 'Tidak Hadir', 'Check-in'];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => Obx(() {
          final isSelected = controller.filterStatus.value == filters[i];
          return GestureDetector(
            onTap: () => controller.filterStatus.value = filters[i],
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? Colors.transparent : AppColors.textHint.withOpacity(0.3)),
              ),
              child: Text(filters[i],
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textSecondary)),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGuestList() {
    return Obx(() {
      final list = controller.filteredGuests;
      if (list.isEmpty) {
        return const EmptyState(
          icon: Icons.people_outline_rounded,
          title: 'Tidak Ada Tamu',
          subtitle: 'Belum ada tamu yang sesuai filter',
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _GuestTile(guest: list[i], onQR: () => controller.goToQRCode(list[i])),
      );
    });
  }
}

class _GuestTile extends StatelessWidget {
  final GuestModel guest;
  final VoidCallback onQR;
  const _GuestTile({required this.guest, required this.onQR});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    if (guest.checkedIn) {
      statusColor = AppColors.info;
      statusLabel = 'Check-in';
      statusIcon = Icons.verified_rounded;
    } else if (guest.hadir) {
      statusColor = AppColors.success;
      statusLabel = 'Hadir';
      statusIcon = Icons.check_circle_rounded;
    } else {
      statusColor = AppColors.error;
      statusLabel = 'Tidak Hadir';
      statusIcon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                guest.nama[0].toUpperCase(),
                style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(guest.nama, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(guest.nomorHP, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, size: 12, color: statusColor),
                const SizedBox(width: 4),
                Text(statusLabel, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onQR,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.qr_code_2_rounded, color: AppColors.primary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textSecondary)),
        ],
      );
}
