import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum NotifType { booking, promo, system }

class NotifData {
  final NotifType type;
  final String title;
  final String body;
  final String time;
  final bool isRead;

  NotifData({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });

  NotifData copyWith({bool? isRead}) => NotifData(
        type: type,
        title: title,
        body: body,
        time: time,
        isRead: isRead ?? this.isRead,
      );

  IconData get icon {
    switch (type) {
      case NotifType.booking: return Icons.receipt_long_rounded;
      case NotifType.promo:   return Icons.local_offer_rounded;
      case NotifType.system:  return Icons.notifications_rounded;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotifType.booking: return const Color(0xFFFF6B2C);
      case NotifType.promo:   return const Color(0xFF34D399);
      case NotifType.system:  return const Color(0xFF60A5FA);
    }
  }

  Color get iconBgColor {
    switch (type) {
      case NotifType.booking: return const Color(0xFFFF6B2C).withOpacity(0.1);
      case NotifType.promo:   return const Color(0xFF34D399).withOpacity(0.1);
      case NotifType.system:  return const Color(0xFF60A5FA).withOpacity(0.1);
    }
  }
}

class NotifikasiController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────

  final selectedTabIndex = 0.obs;
  final allNotifs = <NotifData>[].obs;

  // ── Computed ───────────────────────────────────────────────────────────────

  final tabs = ['Semua', 'Pemesanan', 'Promo', 'Sistem'];

  List<NotifData> get filteredNotifs {
    switch (selectedTabIndex.value) {
      case 1:
        return allNotifs.where((n) => n.type == NotifType.booking).toList();
      case 2:
        return allNotifs.where((n) => n.type == NotifType.promo).toList();
      case 3:
        return allNotifs.where((n) => n.type == NotifType.system).toList();
      default:
        return allNotifs.toList();
    }
  }

  int get unreadCount => allNotifs.where((n) => !n.isRead).length;
  bool get hasUnread => unreadCount > 0;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadNotifs();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void selectTab(int index) => selectedTabIndex.value = index;

  void markAsRead(NotifData target) {
    final i = allNotifs.indexOf(target);
    if (i != -1 && !allNotifs[i].isRead) {
      allNotifs[i] = allNotifs[i].copyWith(isRead: true);
      allNotifs.refresh();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < allNotifs.length; i++) {
      if (!allNotifs[i].isRead) {
        allNotifs[i] = allNotifs[i].copyWith(isRead: true);
      }
    }
    allNotifs.refresh();
  }

  void deleteNotif(NotifData target) => allNotifs.remove(target);

  void clearAll() => allNotifs.clear();

  // ── Private ────────────────────────────────────────────────────────────────

  void _loadNotifs() {
    allNotifs.assignAll([
      NotifData(
        type: NotifType.booking,
        title: 'Pemesanan Dikonfirmasi',
        body: 'Foto Studio Bahagia telah mengkonfirmasi pemesanan Anda untuk tanggal 12 Januari 2025.',
        time: '2 menit lalu',
        isRead: false,
      ),
      NotifData(
        type: NotifType.promo,
        title: 'Promo Spesial Akhir Tahun 🎉',
        body: 'Dapatkan diskon hingga 30% untuk semua vendor kategori Fotografer. Berlaku hingga 31 Desember.',
        time: '1 jam lalu',
        isRead: false,
      ),
      NotifData(
        type: NotifType.system,
        title: 'Verifikasi Vendor Berhasil ✅',
        body: 'Selamat! Akun vendor Anda telah diverifikasi. Mulai terima pesanan sekarang.',
        time: '3 jam lalu',
        isRead: true,
      ),
      NotifData(
        type: NotifType.booking,
        title: 'Pembayaran Berhasil',
        body: 'Pembayaran untuk Catering Berkah Jaya sebesar Rp 5.000.000 telah berhasil diproses.',
        time: 'Kemarin',
        isRead: true,
      ),
      NotifData(
        type: NotifType.promo,
        title: 'Vendor Baru di Kota Anda',
        body: 'Ada 5 vendor baru di Jakarta Selatan yang siap melayani hajatan Anda.',
        time: '2 hari lalu',
        isRead: true,
      ),
      NotifData(
        type: NotifType.system,
        title: 'Ulasan Baru Diterima',
        body: 'Pelanggan memberikan bintang 5 untuk layanan Anda. Pertahankan kualitasnya!',
        time: '3 hari lalu',
        isRead: true,
      ),
      NotifData(
        type: NotifType.booking,
        title: 'Pengingat Acara',
        body: 'Acara pernikahan Budi & Ani akan berlangsung 3 hari lagi. Pastikan semua persiapan siap.',
        time: '5 hari lalu',
        isRead: true,
      ),
    ]);
  }
}