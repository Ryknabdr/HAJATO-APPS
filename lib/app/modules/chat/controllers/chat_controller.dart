import 'package:get/get.dart';
import '../../../data/models/models.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  final messages = <MessageModel>[].obs;
  final messageInput = ''.obs;
  final inputController = ''.obs;

  final String vendorName;
  ChatController({this.vendorName = 'Vendor'});

  @override
  void onInit() {
    super.onInit();
    _loadSampleMessages();
  }

  void _loadSampleMessages() {
    messages.assignAll([
      MessageModel(
        id: const Uuid().v4(),
        senderId: 'vendor',
        message: 'Halo! Ada yang bisa saya bantu? ',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isMe: false,
      ),
      MessageModel(
        id: const Uuid().v4(),
        senderId: 'me',
        message: 'Halo, saya tertarik dengan paket wedding Anda',
        timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
        isMe: true,
      ),
      MessageModel(
        id: const Uuid().v4(),
        senderId: 'vendor',
        message: 'Tentu! Kami memiliki beberapa paket menarik. Silakan lihat detail paket di halaman layanan kami 🎉',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        isMe: false,
      ),
    ]);
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
    // Simulate vendor reply
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(MessageModel(
        id: const Uuid().v4(),
        senderId: 'vendor',
        message: 'Terima kasih pesan Anda! Kami akan segera membalas. 🙏',
        timestamp: DateTime.now(),
        isMe: false,
      ));
    });
  }
}
