import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/chatbot_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';

class ChatbotView extends GetView<ChatbotController> {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    final inputCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 28, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HAJATO AI', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text('Asisten Cerdas', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.success)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.surfaceVariant, height: 1),
        ),
      ),
      body: Column(
        children: [
          // Quick action chips
          _buildQuickChips(),
          // Messages
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == controller.messages.length && controller.isTyping.value) {
                      return _TypingIndicator();
                    }
                    final msg = controller.messages[i];
                    return _BotBubble(message: msg);
                  },
                )),
          ),
          // Input
          _buildInputBar(context, inputCtrl),
        ],
      ),
    );
  }

  Widget _buildQuickChips() {
    final chips = ['Cari Fotografer', 'Budget 5 Juta', 'Vendor Terbaik', 'Acara Pernikahan'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => controller.sendMessage(chips[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Text(chips[i], style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, TextEditingController inputCtrl) {
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
              hintText: 'Tanya HAJATO AI...',
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
              controller.sendMessage(inputCtrl.text);
              inputCtrl.clear();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ),
      ]),
    );
  }
}

class _BotBubble extends StatelessWidget {
  final MessageModel message;
  const _BotBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('HAJATO AI', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isMe ? AppColors.primaryGradient : null,
                    color: isMe ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 20),
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                  ),
                  child: Text(
                    message.message,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: isMe ? Colors.white : AppColors.textPrimary,
                        height: 1.6),
                  ),
                ),
                const SizedBox(height: 3),
                Text(DateFormat('HH:mm').format(message.timestamp),
                    style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textHint)),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.surfaceVariant,
              child: Icon(Icons.person, size: 16, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with TickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, __) {
                      final offset = (i * 0.3).clamp(0.0, 1.0);
                      final animValue = (_ctrl.value - offset).abs();
                      return Container(
                        margin: const EdgeInsets.only(right: 4),
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.3 + 0.7 * (1 - animValue)),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
