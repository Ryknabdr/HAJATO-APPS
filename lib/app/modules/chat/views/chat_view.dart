import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_config.dart';
import '../../../services/chat_api.dart';
import '../../../services/chat_service.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController messageController = 
    TextEditingController();

  final ScrollController scrollController =
    ScrollController();

  late String chatId;
  late String senderId;
  late String senderRole;
  late String receiverName;
  late String receiverId;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};

    chatId = args['chat_id'] ?? '';
    senderId = args['sender_id'] ?? '';
    senderRole = args['sender_role'] ?? '';
    receiverName = args['receiver_name'] ?? 'Chat';
    receiverId = args['receiver_id'] ?? '';

    if (senderRole == 'vendor') {
      ChatService.markVendorChatAsRead(chatId);
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    await ChatService.sendMessage(
      chatId: chatId,
      senderId: senderId,
      senderRole: senderRole,
      message: text,
    );

    await ChatApi.sendNotification(
      receiverId: receiverId,
      message: text,
      chatId: chatId,
      receiverName: receiverName,
      senderRole: senderRole,
    );

    messageController.clear();
  }

  Future<void> pickAndSendImage() async {
    try {
      final picker = ImagePicker();

      final file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (file == null) return;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/api/chat/upload-image'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          file.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('UPLOAD CHAT IMAGE STATUS: ${response.statusCode}');
      print('UPLOAD CHAT IMAGE BODY: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final imageUrl = data['image_url'] ?? '';

        await ChatService.sendImageMessage(
          chatId: chatId,
          senderId: senderId,
          senderRole: senderRole,
          imageUrl: imageUrl,
        );

        await ChatApi.sendNotification(
          receiverId: receiverId,
          message: '📷 Mengirim gambar',
          chatId: chatId,
          receiverName: receiverName,
          senderRole: senderRole,
        );
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Gagal upload gambar',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('IMAGE ERROR: $e');

      Get.snackbar(
        'Error',
        'Tidak dapat mengirim gambar',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: ChatService.getMessages(chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data!.docs;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                if (docs.isEmpty) {
                  return const Center(
                    child: Text('Belum ada pesan'),
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data =
                        docs[index].data() as Map<String, dynamic>;

                    final isMe = data['sender_id'] == senderId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.teal : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (data['type'] == 'image')
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data['image_url'] ?? '',
                                  width: 180,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Text(
                                data['message'] ?? '',
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              _formatChatTime(data['created_at']),
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    isMe ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: pickAndSendImage,
                    icon: const Icon(Icons.image),
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Ketik pesan...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatChatTime(dynamic timestamp) {
  if (timestamp == null) return '';

  try {
    final date = (timestamp as Timestamp).toDate();
    return DateFormat('HH:mm').format(date);
  } catch (e) {
    return '';
  }
}