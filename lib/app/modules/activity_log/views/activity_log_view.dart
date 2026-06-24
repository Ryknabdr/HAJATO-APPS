import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/activity_log_controller.dart';

class ActivityLogView extends GetView<ActivityLogController> {
  const ActivityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Aktivitas Saya',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        return Column(
          children: [
            _CategoryFilter(controller: controller),

            Expanded(
              child: controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                      : controller.logs.isEmpty
                          ? _EmptyActivityState(
                              category: controller.selectedCategory.value,
                            )
                      : RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () {
                            return controller.fetchMyActivityLogs(
                              isRefresh: true,
                            );
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              20,
                              8,
                              20,
                              20,
                            ),
                            itemCount: controller.logs.length +
                                (controller.hasMore.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == controller.logs.length) {
                                return _LoadMoreButton(
                                  controller: controller,
                                );
                              }

                              final log = controller.logs[index];

                              final showHeader =
                                  _shouldShowDateHeader(index);

                              return Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  if (showHeader)
                                    _DateHeader(
                                      title: _getDateHeader(
                                        log['timestamp'],
                                      ),
                                    ),

                                  _ActivityCard(log: log),

                                  const SizedBox(height: 12),
                                ],
                              );
                            },
                          ),
                        ),
            ),
          ],
        );
      }),
    );
  }

  bool _shouldShowDateHeader(int index) {
    if (index == 0) {
      return true;
    }

    final currentLog = controller.logs[index];
    final previousLog = controller.logs[index - 1];

    final currentHeader = _getDateHeader(
      currentLog['timestamp'],
    );

    final previousHeader = _getDateHeader(
      previousLog['timestamp'],
    );

    return currentHeader != previousHeader;
  }

  String _getDateHeader(dynamic timestamp) {
    if (timestamp == null) {
      return 'Tanggal tidak diketahui';
    }

    try {
      final date = DateTime.parse(
        timestamp.toString(),
      ).toLocal();

      final now = DateTime.now();

      final today = DateTime(
        now.year,
        now.month,
        now.day,
      );

      final yesterday = today.subtract(
        const Duration(days: 1),
      );

      final logDate = DateTime(
        date.year,
        date.month,
        date.day,
      );

      if (logDate == today) {
        return 'Hari Ini';
      }

      if (logDate == yesterday) {
        return 'Kemarin';
      }

      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();

      return '$day/$month/$year';
    } catch (e) {
      return 'Tanggal tidak diketahui';
    }
  }
}

class _CategoryFilter extends StatelessWidget {
  final ActivityLogController controller;

  const _CategoryFilter({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: SizedBox(
        height: 38,
        child: Obx(() {
          final selectedCategory = controller.selectedCategory.value;
          final categories = controller.categories;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];

              final label = category['label'] ?? '';
              final value = category['value'] ?? '';

              final isSelected = selectedCategory == value;

              return GestureDetector(
                onTap: () {
                  controller.changeCategory(value);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.18),
                    ),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : AppColors.primary,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String title;

  const _DateHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 14,
        bottom: 10,
      ),
      child: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}


class _EmptyActivityState extends StatelessWidget {
  final String category;

  const _EmptyActivityState({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_toggle_off_rounded,
              size: 56,
              color: AppColors.primary.withOpacity(0.45),
            ),

            const SizedBox(height: 14),

            Text(
              _getEmptyTitle(),
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Aktivitas akan muncul otomatis setelah kamu menggunakan fitur terkait.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmptyTitle() {
    switch (category) {
      case 'akun':
        return 'Belum ada aktivitas akun';
      case 'booking':
        return 'Belum ada aktivitas booking';
      case 'pembayaran':
        return 'Belum ada aktivitas pembayaran';
      case 'review':
        return 'Belum ada aktivitas review';
      case 'vendor':
        return 'Belum ada aktivitas vendor';
      case 'paket':
        return 'Belum ada aktivitas paket';
      case 'dana':
        return 'Belum ada aktivitas dana';
      case 'status_vendor':
        return 'Belum ada aktivitas status vendor';
      default:
        return 'Belum ada aktivitas';
    }
  }
}

class _ActivityCard extends StatelessWidget {
  final Map<String, dynamic> log;

  const _ActivityCard({
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showActivityDetail();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFB2DFDB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ActivityIcon(
              action: log['action'] ?? '',
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log['title'] ?? '-',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    log['description'] ?? '-',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    log['created_at'] ?? '-',
                    style: GoogleFonts.dmSans(
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
    );
  }

  void _showActivityDetail() {
    final metadata = log['metadata'];

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.75,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ActivityIcon(
                      action: log['action'] ?? '',
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log['title'] ?? 'Aktivitas',
                            style: GoogleFonts.dmSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            log['created_at'] ?? '-',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Text(
                  log['description'] ?? '-',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 20),

                _DetailItem(
                  label: 'Action',
                  value: log['action'] ?? '-',
                ),

                if (metadata is Map && metadata.isNotEmpty) ...[
                  const SizedBox(height: 18),

                  Text(
                    'Detail Aktivitas',
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...metadata.entries
                      .where((entry) {
                        return !_shouldHideMetadata(entry.key.toString());
                      })
                      .map((entry) {
                        return _DetailItem(
                          label: _formatLabel(entry.key.toString()),
                          value: _formatValue(
                            entry.key.toString(),
                            entry.value,
                          ),
                        );
                      }).toList(),
                ],
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  String _formatLabel(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
  bool _shouldHideMetadata(String key) {
  final hiddenKeys = [
    'vendor_id',
    'package_id',
    'service_id',
    'review_id',
  ];

  return hiddenKeys.contains(key);
}

String _formatValue(String key, dynamic value) {
  if (value == null) {
    return '-';
  }

  if (key == 'total_price') {
    final number = int.tryParse(value.toString()) ?? 0;

    return 'Rp ${number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  if (key == 'payment_status') {
    switch (value.toString()) {
      case 'pending_payment':
        return 'Menunggu pembayaran';
      case 'paid':
        return 'Sudah dibayar';
      case 'failed':
        return 'Gagal';
      default:
        return value.toString();
    }
  }

  if (key == 'booking_status') {
    switch (value.toString()) {
      case 'pending_payment':
        return 'Menunggu pembayaran';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'completed':
        return 'Selesai';
      default:
        return value.toString();
    }
  }

  if (key == 'vendor_payout_status') {
    switch (value.toString()) {
      case 'hold':
        return 'Dana ditahan';
      case 'released':
        return 'Dana dicairkan';
      default:
        return value.toString();
    }
  }

  return value.toString();
}
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty || value == 'null') {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  final ActivityLogController controller;

  const _LoadMoreButton({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 20,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton(
            onPressed: controller.isLoadingMore.value
                ? null
                : controller.loadMore,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppColors.primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: controller.isLoadingMore.value
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : Text(
                    'Muat Lagi',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
          ),
        ),
      );
    });
  }
}

class _ActivityIcon extends StatelessWidget {
  final String action;

  const _ActivityIcon({
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedAction = action.toUpperCase().trim();

    final IconData icon = _getIcon(normalizedAction);

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }

  IconData _getIcon(String action) {
    if (action == 'LOGIN') {
      return Icons.login_rounded;
    }

    if (action == 'LOGOUT') {
      return Icons.logout_rounded;
    }

    if (action == 'REGISTER') {
      return Icons.person_add_alt_1_rounded;
    }

    if (action == 'VERIFY_REGISTER_OTP') {
      return Icons.verified_user_rounded;
    }

    if (action == 'RESET_PASSWORD') {
      return Icons.lock_reset_rounded;
    }

    if (action == 'UPDATE_PROFILE') {
      return Icons.person_outline_rounded;
    }

    if (action == 'CREATE_BOOKING' ||
        action.startsWith('CREATE_BOOKING')) {
      return Icons.event_available_rounded;
    }

    if (action == 'CANCEL_BOOKING' ||
        action.startsWith('CANCEL_BOOKING')) {
      return Icons.event_busy_rounded;
    }

    if (action == 'CREATE_PAYMENT' ||
        action == 'PAYMENT_PENDING' ||
        action.startsWith('CREATE_PAYMENT')) {
      return Icons.payment_rounded;
    }

    if (action == 'PAYMENT_SUCCESS' ||
        action.startsWith('PAYMENT_SUCCESS')) {
      return Icons.check_circle_rounded;
    }

    if (action == 'PAYMENT_FAILED' ||
        action.startsWith('PAYMENT_FAILED')) {
      return Icons.cancel_rounded;
    }

    if (action == 'CREATE_REVIEW' ||
        action == 'ADD_REVIEW' ||
        action.startsWith('ADD_REVIEW')) {
      return Icons.star_rate_rounded;
    }

    if (action == 'UPDATE_REVIEW') {
      return Icons.rate_review_rounded;
    }

    if (action == 'DELETE_REVIEW') {
      return Icons.delete_outline_rounded;
    }

    if (action == 'VENDOR_REGISTER' ||
        action.startsWith('VENDOR_REGISTER')) {
      return Icons.storefront_rounded;
    }

    if (action == 'VENDOR_APPROVED') {
      return Icons.verified_rounded;
    }

    if (action == 'VENDOR_REJECTED') {
      return Icons.block_rounded;
    }

    if (action == 'UPDATE_VENDOR_PROFILE') {
      return Icons.store_mall_directory_outlined;
    }

    if (action == 'CREATE_PACKAGE' ||
        action == 'ADD_SERVICE' ||
        action.startsWith('ADD_SERVICE')) {
      return Icons.add_business_rounded;
    }

    if (action == 'UPDATE_PACKAGE' ||
        action == 'EDIT_SERVICE' ||
        action.startsWith('EDIT_SERVICE')) {
      return Icons.edit_note_rounded;
    }

    if (action == 'DELETE_PACKAGE' ||
        action == 'DELETE_SERVICE' ||
        action.startsWith('DELETE_SERVICE')) {
      return Icons.delete_sweep_rounded;
    }

    if (action == 'RECEIVE_BOOKING') {
      return Icons.mark_email_read_rounded;
    }

    if (action == 'ACCEPT_BOOKING') {
      return Icons.done_all_rounded;
    }

    if (action == 'REJECT_BOOKING') {
      return Icons.close_rounded;
    }

    if (action == 'COMPLETE_BOOKING' ||
        action.startsWith('COMPLETE_BOOKING')) {
      return Icons.task_alt_rounded;
    }

    if (action == 'PAYOUT_RELEASED') {
      return Icons.account_balance_wallet_rounded;
    }

    return Icons.history_rounded;
  }
}