import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/api_config.dart';

class ChatApi {
  static Future<void> sendNotification({
    required String receiverId,
    required String message,
    required String chatId,
    required String receiverName,
    required String senderRole,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token') ?? '';

      await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/chat/notify',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'receiver_id': receiverId,
          'title': 'Pesan Baru',
          'message': message,
          'chat_id': chatId,
          'receiver_name': receiverName,
          'sender_role': senderRole,
        }),
      );
    } catch (e) {
      print('SEND CHAT NOTIFICATION ERROR: $e');
    }
  }
}