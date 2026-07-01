import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/chat_service.dart';
import '../../../routes/app_routes.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  String currentUserId = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('user_id') ?? ''; 
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUserId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat Vendor')),
        body: const Center(child: Text('Sesi user tidak ditemukan. Silakan login ulang.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Vendor'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('user_id', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(
              child: Text('Belum ada chat vendor'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final data = chats[index].data() as Map<String, dynamic>;
              final chatId = chats[index].id;

              // Ambil status unread khusus sisi user/pelanggan
              final unread = data['unread_user'] ?? 0; 
              final time = _formatChatListTime(data['updated_at']);

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['vendor_name'] ?? 'Vendor',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (unread > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$unread',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['last_message'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    // ── 🟢 RESET ANGKA UNREAD USER DI FIRESTORE SEBELUM MASUK ROOM ──
                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .update({
                      'unread_user': 0,
                    });

                    Get.toNamed(
                      AppRoutes.chatViewRoom,
                      arguments: {
                        'chat_id': chatId,
                        'receiver_name': data['vendor_name'] ?? 'Vendor',
                        'receiver_id': data['vendor_id'],
                        'sender_id': currentUserId,
                        'sender_role': 'user',
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

String _formatChatListTime(dynamic timestamp) {
  if (timestamp == null) return '';

  try {
    final date = (timestamp as Timestamp).toDate();
    final now = DateTime.now();

    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    if (isToday) {
      return DateFormat('HH:mm').format(date);
    }

    return DateFormat('dd/MM').format(date);
  } catch (e) {
    return '';
  }
}