import 'package:get/get.dart';
import '../../../data/models/models.dart';
import 'package:uuid/uuid.dart';

class ChatbotController extends GetxController {
  final messages = <MessageModel>[].obs;
  final isTyping = false.obs;
  final stage = 0.obs; // conversation stages

  final _replies = [
    'Halo! Mau cari vendor apa hari ini? 😊\nKami punya Fotografer, Catering, Tenda, Makeup, Sound System, dan Wedding Organizer.',
    'Bagus! Budget kamu berapa untuk acara ini?\nContoh: 5 juta, 10 juta, dsb.',
    'Siap! Berikut rekomendasi vendor terbaik sesuai budget kamu:\n\n📷 Lensa Pro Studio - mulai Rp 1.500.000\n🍽️ Nusantara Catering - mulai Rp 2.500.000\n💍 Mahkota Wedding Organizer - mulai Rp 5.000.000\n\nMau lihat detail vendor tertentu?',
    'Tentu! Silakan kunjungi halaman Vendor untuk melihat detail lengkap dan melakukan pemesanan. Ada yang bisa saya bantu lagi? 🎉',
  ];

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500), () {
      _addBotMessage(_replies[0]);
    });
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    messages.add(MessageModel(
      id: const Uuid().v4(),
      senderId: 'me',
      message: text.trim(),
      timestamp: DateTime.now(),
      isMe: true,
    ));
    _simulateReply();
  }

  void _simulateReply() {
    isTyping.value = true;
    Future.delayed(const Duration(milliseconds: 1200), () {
      isTyping.value = false;
      final idx = stage.value < _replies.length - 1 ? stage.value + 1 : _replies.length - 1;
      stage.value = idx;
      _addBotMessage(_replies[idx]);
    });
  }

  void _addBotMessage(String msg) {
    messages.add(MessageModel(
      id: const Uuid().v4(),
      senderId: 'bot',
      message: msg,
      timestamp: DateTime.now(),
      isMe: false,
    ));
  }
}
