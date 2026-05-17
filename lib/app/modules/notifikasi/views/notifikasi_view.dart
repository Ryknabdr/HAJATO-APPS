import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/notifikasi_controller.dart';
import '../../../core/theme/app_theme.dart';

class NotifikasiView extends GetView<NotifikasiController> {
  const NotifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(child: _buildList()),
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
          // Tombol back
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifikasi',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                Obx(() => Text(
                      controller.hasUnread
                          ? '${controller.unreadCount} belum dibaca'
                          : 'Semua sudah dibaca',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: controller.hasUnread
                            ? AppColors.primary
                            : AppColors.textHint,
                        fontWeight: controller.hasUnread
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    )),
              ],
            ),
          ),
          // Tombol tandai semua
          Obx(() => controller.hasUnread
              ? GestureDetector(
                  onTap: controller.markAllAsRead,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Tandai semua',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : const SizedBox()),
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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: List.generate(controller.tabs.length, (i) {
                    final isSelected = controller.selectedTabIndex.value == i;
                    return GestureDetector(
                      onTap: () => controller.selectTab(i),
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
                          controller.tabs[i],
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
                  }),
                ),
              )),
        ],
      ),
    );
  }

  // ── LIST ─────────────────────────────────────────────────
  Widget _buildList() {
    return Obx(() {
      final notifs = controller.filteredNotifs;

      if (notifs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_off_outlined,
                size: 48,
                color: AppColors.textHint,
              ),
              const SizedBox(height: 12),
              Text(
                'Belum ada notifikasi',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Aktivitas Anda akan muncul di sini',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        );
      }

      // Kelompokkan: unread dulu, lalu read
      final unread = notifs.where((n) => !n.isRead).toList();
      final read = notifs.where((n) => n.isRead).toList();

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          if (unread.isNotEmpty) ...[
            _GroupLabel('Baru'),
            const SizedBox(height: 8),
            ...unread.map((n) => _NotifTile(
                  notif: n,
                  onTap: () => controller.markAsRead(n),
                  onDismiss: () => controller.deleteNotif(n),
                )),
            const SizedBox(height: 16),
          ],
          if (read.isNotEmpty) ...[
            _GroupLabel('Sebelumnya'),
            const SizedBox(height: 8),
            ...read.map((n) => _NotifTile(
                  notif: n,
                  onTap: () => controller.markAsRead(n),
                  onDismiss: () => controller.deleteNotif(n),
                )),
          ],
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
// GROUP LABEL
// ─────────────────────────────────────────────────────────────

class _GroupLabel extends StatelessWidget {
  final String label;
  const _GroupLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textHint,
        letterSpacing: 0.3,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// NOTIF TILE
// ─────────────────────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  final NotifData notif;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotifTile({
    required this.notif,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEEEE),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Color(0xFFE53935), size: 22),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notif.isRead ? Colors.white : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: notif.isRead
                  ? const Color(0xFFEEEEEE)
                  : AppColors.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: notif.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(notif.icon, color: notif.iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              // Konten
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: notif.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 7,
                            height: 7,
                            margin: const EdgeInsets.only(left: 6, top: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      notif.body,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif.time,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}