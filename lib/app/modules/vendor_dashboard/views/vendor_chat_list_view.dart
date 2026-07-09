import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vendor_dashboard_controller.dart';
import '../../../services/chat_service.dart';
import '../../../routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class VendorChatListView extends GetView<VendorDashboardController> {
  const VendorChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Pelanggan'),
      ),
      body: Obx(() {
        if (controller.vendorId.value.isEmpty) {
          controller.fetchDashboardStats();

          return const Center(
            child: Text('Memuat data chat...'),
          );
        }

        print('VENDOR ID DI CHAT LIST: ${controller.vendorId.value}');


        return StreamBuilder(
          stream: ChatService.getVendorChats(
            controller.vendorId.value,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final chats = snapshot.data!.docs;

            if (chats.isEmpty) {
              return const Center(
                child: Text('Belum ada chat pelanggan'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final data =
                    chats[index].data() as Map<String, dynamic>;

                final unread = data['unread_vendor'] ?? 0;
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
                            data['user_name'] ?? 'Customer',
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
                    onTap: () {
                    Get.toNamed(
                      AppRoutes.chatViewRoom,
                      arguments: {
                        'chat_id': data['chat_id'],
                        'receiver_name': data['user_name'] ?? 'Customer',
                        'receiver_id': data['user_id'],
                        'sender_id': controller.vendorId.value,
                        'sender_role': 'vendor',
                      },
                    );
                    },
                  ),
                );
              },
            );
          },
        );
      }),
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