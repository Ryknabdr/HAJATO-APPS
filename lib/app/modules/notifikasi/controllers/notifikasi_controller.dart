import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_config.dart';

enum NotifType { booking, promo, system }

class NotifData {
  final String id;
  final NotifType type;
  final String title;
  final String body;
  final String time;
  final bool isRead;

  NotifData({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });

  NotifData copyWith({bool? isRead}) => NotifData(
        id: id,
        type: type,
        title: title,
        body: body,
        time: time,
        isRead: isRead ?? this.isRead,
      );

  IconData get icon {
    switch (type) {
      case NotifType.booking:
        return Icons.receipt_long_rounded;
      case NotifType.promo:
        return Icons.local_offer_rounded;
      case NotifType.system:
        return Icons.notifications_rounded;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotifType.booking:
        return const Color(0xFFFF6B2C);
      case NotifType.promo:
        return const Color(0xFF34D399);
      case NotifType.system:
        return const Color(0xFF60A5FA);
    }
  }

  Color get iconBgColor {
    switch (type) {
      case NotifType.booking:
        return const Color(0xFFFF6B2C).withOpacity(0.1);
      case NotifType.promo:
        return const Color(0xFF34D399).withOpacity(0.1);
      case NotifType.system:
        return const Color(0xFF60A5FA).withOpacity(0.1);
    }
  }
}

class NotifikasiController extends GetxController {
  final selectedTabIndex = 0.obs;
  final allNotifs = <NotifData>[].obs;
  final isLoading = false.obs;

  final tabs = ['Semua', 'Pemesanan', 'Promo', 'Sistem'];

  @override
  void onInit() {
    super.onInit();
    loadNotifs();
  }

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

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> loadNotifs() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/notifications/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('NOTIFICATION STATUS: ${response.statusCode}');
      print('NOTIFICATION BODY: ${response.body}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        allNotifs.assignAll(
          data.map((notif) {
            return NotifData(
              id: notif['id'] ?? '',
              type: NotifType.booking,
              title: notif['title'] ?? '',
              body: notif['message'] ?? '',
              time: notif['created_at'] ?? '',
              isRead: notif['is_read'] ?? false,
            );
          }).toList(),
        );
      }
    } catch (e) {
      print('LOAD NOTIFICATION ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(NotifData target) async {
    try {
      final i = allNotifs.indexOf(target);

      if (i != -1 && !allNotifs[i].isRead) {
        allNotifs[i] = allNotifs[i].copyWith(isRead: true);
        allNotifs.refresh();
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      await http.put(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/notifications/read/${target.id}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print('MARK NOTIFICATION ERROR: $e');
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

  void deleteNotif(NotifData target) {
    allNotifs.remove(target);
  }

  void clearAll() {
    allNotifs.clear();
  }
}