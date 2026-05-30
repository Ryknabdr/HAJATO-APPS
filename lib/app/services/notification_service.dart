import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

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
      );
    });
  }
}