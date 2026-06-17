import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class NotificationService {
  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  static Future<void> init() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('PERMISSION: ${settings.authorizationStatus}');

    final token = await _messaging.getToken();

    print('======================');
    print('FCM TOKEN: $token');
    print('======================');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'HAJATO';
      final body = message.notification?.body ?? '';

      Get.snackbar(
        title,
        body,
        snackPosition: SnackPosition.TOP,
        onTap: (_) {
          _handleNotificationClick(message);
        },
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message);
    });

    final initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationClick(initialMessage);
    }
  }

  static void _handleNotificationClick(RemoteMessage message) {
    final data = message.data;

    print('NOTIFICATION DATA: $data');

    if (data['type'] == 'chat') {
      Get.toNamed(
        AppRoutes.chat,
        arguments: {
          'chat_id': data['chat_id'] ?? '',
          'receiver_id': data['receiver_id'] ?? '',
          'receiver_name': data['receiver_name'] ?? 'Chat',
          'sender_id': data['receiver_id'] ?? '',
          'sender_role': data['sender_role'] == 'user'
              ? 'vendor'
              : 'user',
        },
      );
    }
  }
}