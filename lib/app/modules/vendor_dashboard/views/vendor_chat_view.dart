import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../modules/chat/controllers/chat_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';

class VendorChatView extends StatelessWidget {
  const VendorChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ChatController(vendorName: 'Vendor'));
    final inputCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceVariant,
              child: Icon(Icons.person, color: AppColors.textSecondary, size: 18),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Ahmad Fauzi', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text('Pelanggan', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
            ]),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.surfaceVariant, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: true,
                  itemCount: ctrl.messages.length,
                  itemBuilder: (_, i) {
                    final msg = ctrl.messages[ctrl.messages.length - 1 - i];
                    return _VendorBubble(message: msg);
                  },
                )),
          ),
          _buildInputBar(context, ctrl, inputCtrl),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, ChatController ctrl, TextEditingController inputCtrl) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, -3))],
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: inputCtrl,
            decoration: InputDecoration(
              hintText: 'Balas pelanggan...',
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            if (inputCtrl.text.isNotEmpty) {
              ctrl.sendMessage(inputCtrl.text);
              inputCtrl.clear();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF7B4FBA), Color(0xFF4F6AF5)]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ),
      ]),
    );
  }
}

class _VendorBubble extends StatelessWidget {
  final MessageModel message;
  const _VendorBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.surfaceVariant,
              child: Icon(Icons.person, size: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isMe ? const LinearGradient(colors: [Color(0xFF7B4FBA), Color(0xFF4F6AF5)]) : null,
                    color: isMe ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                  ),
                  child: Text(message.message,
                      style: GoogleFonts.poppins(fontSize: 13, color: isMe ? Colors.white : AppColors.textPrimary, height: 1.5)),
                ),
                const SizedBox(height: 3),
                Text(DateFormat('HH:mm').format(message.timestamp),
                    style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textHint)),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 28, height: 28,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF7B4FBA), Color(0xFF4F6AF5)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.store_rounded, color: Colors.white, size: 14),
            ),
          ],
        ],
      ),
    );
  }
}
