import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../modules/chat/controllers/chat_controller.dart';
import '../../../data/models/models.dart';
import '../../../core/theme/app_theme.dart';

class VendorChatView extends StatelessWidget {
  const VendorChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ChatController());
    final inputCtrl = TextEditingController();
    final focusNode = FocusNode();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Row(children: [
          // Avatar pelanggan
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('A',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
            ),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ahmad Fauzi',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Row(children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                    color: AppColors.success, shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
              Text('Online',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.success)),
            ]),
          ]),
        ]),
        actions: [
          IconButton(
            icon: Icon(Icons.phone_rounded,
                color: AppColors.primary, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded,
                color: AppColors.textSecondary, size: 20),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFB2DFDB), height: 1),
        ),
      ),
      body: Column(children: [
        // ── Info booking banner ──────────────────────────────────────────────
        Container(
          margin: const EdgeInsets.all(12),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: AppColors.primary.withOpacity(0.15)),
          ),
          child: Row(children: [
            Icon(Icons.receipt_long_rounded,
                color: AppColors.primary, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Paket Basic  •  20 Juni 2025  •  Rp 1.500.000',
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8)),
              child: Text('Dikonfirmasi',
                  style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success)),
            ),
          ]),
        ),

        // ── Pesan ────────────────────────────────────────────────────────────
        Expanded(
          child: Obx(() => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                reverse: true,
                itemCount: ctrl.messages.length,
                itemBuilder: (_, i) {
                  final msg =
                      ctrl.messages[ctrl.messages.length - 1 - i];
                  return _ChatBubble(message: msg);
                },
              )),
        ),

        // ── Quick reply chips ────────────────────────────────────────────────
        SizedBox(
          height: 40,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            children: [
              _QuickReply('Halo! Ada yang bisa saya bantu?'),
              _QuickReply('Jadwal masih tersedia 👍'),
              _QuickReply('Terima kasih sudah memesan!'),
              _QuickReply('Akan saya cek dulu'),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ── Input bar ────────────────────────────────────────────────────────
        Container(
          padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -3))
            ],
          ),
          child: Row(children: [
            // Attachment
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.attach_file_rounded,
                    color: AppColors.textSecondary, size: 20),
              ),
            ),
            const SizedBox(width: 8),

            // Text field
            Expanded(
              child: TextField(
                controller: inputCtrl,
                focusNode: focusNode,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Balas pelanggan...',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Send button
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
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Bubble chat ───────────────────────────────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final MessageModel message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('A',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 7),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isMe ? AppColors.primaryGradient : null,
                    color: isMe ? null : AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    border: isMe
                        ? null
                        : Border.all(
                            color: const Color(0xFFB2DFDB), width: 1),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6)
                    ],
                  ),
                  child: Text(message.message,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: isMe
                              ? Colors.white
                              : AppColors.textPrimary,
                          height: 1.4)),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        DateFormat('HH:mm').format(message.timestamp),
                        style: GoogleFonts.poppins(
                            fontSize: 10, color: AppColors.textHint)),
                    if (isMe) ...[
                      const SizedBox(width: 3),
                      Icon(Icons.done_all_rounded,
                          size: 13, color: AppColors.primary),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 7),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.store_rounded,
                    color: Colors.white, size: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Quick reply chip ──────────────────────────────────────────────────────────
class _QuickReply extends StatelessWidget {
  final String text;
  const _QuickReply(this.text);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.07),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.primary,
                fontWeight: FontWeight.w600)),
      );
}