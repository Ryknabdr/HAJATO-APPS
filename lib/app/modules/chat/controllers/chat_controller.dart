import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  // ── 🟢 1. STATE UNTUK DAFTAR RIWAYAT CHAT (CHAT LIST VIEW) ──
  final chatHistory = <Map<String, dynamic>>[].obs;

  // ── 🟢 2. STATE UNTUK KAMAR OBROLAN PRIVAT (ROOM CHAT VIEW) ──
  final messages = <MessageModel>[].obs;
  final messageInput = ''.obs;
  final inputController = ''.obs;

  // Kita ubah vendorName jadi RxString reaktif biar namanya dinamis pas diklik
  final rxVendorName = 'Vendor'.obs; 
  final activeVendorId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleChatHistory();
  }

  // Menampilkan daftar riwayat chat di halaman utama inbox pesan
  void _loadSampleChatHistory() {
    chatHistory.assignAll([
      {
        'vendor_id': 'v1',
        'vendor_name': 'Raihan Catering & Decoration',
        'last_message': 'Tentu! Kami memiliki beberapa paket menarik...',
        'time': '14:30',
        'unread_count': 2,
      },
      {
        'vendor_id': 'v2',
        'vendor_name': 'Lodeonby Photography',
        'last_message': 'Foto Grid Studio untuk cinematic ready ya kak.',
        'time': 'Kemarin',
        'unread_count': 0,
      },
      {
        'vendor_id': 'v3',
        'vendor_name': 'Hajatan Barokah WO',
        'last_message': 'Sama-sama kak, ditunggu kabar baiknya.',
        'time': '2 hari lalu',
        'unread_count': 0,
      },
    ]);
  }

  // Aksi pas user nge-klik salah satu vendor di ChatListView
  void openChatRoom(Map<String, dynamic> chat) {
    rxVendorName.value = chat['vendor_name'];
    activeVendorId.value = chat['vendor_id'];
    
    // Load isi obrolan tiruan berdasarkan vendor yang dipilih
    _loadSampleMessagesForRoom(chat['vendor_name']);

    // Set unread count jadi 0 (ditandai sudah dibaca)
    final index = chatHistory.indexWhere((element) => element['vendor_id'] == chat['vendor_id']);
    if (index != -1) {
      var updatedChat = Map<String, dynamic>.from(chatHistory[index]);
      updatedChat['unread_count'] = 0;
      chatHistory[index] = updatedChat;
    }

    // Melesat ke halaman kamar obrolan pribadi (ChatView)
    Get.toNamed(AppRoutes.chatViewRoom); 
  }

  // Isi data balon obrolan di dalam room chat privat
  void _loadSampleMessagesForRoom(String vendorName) {
    messages.assignAll([
      MessageModel(
        id: const Uuid().v4(),
        senderId: 'vendor',
        message: 'Halo! Ada yang bisa kami bantu dari pihak $vendorName? ',
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

  // Aksi kirim pesan baru oleh user
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    // 1. Tambah balon chat user ke dalam room
    messages.add(MessageModel(
      id: const Uuid().v4(),
      senderId: 'me',
      message: text.trim(),
      timestamp: DateTime.now(),
      isMe: true,
    ));

    // Update info teks terakhir di halaman depan ChatList
    _updateLastMessageInList(text.trim());

    // 2. Simulasi balasan otomatis dari vendor dalam 1 detik
    Future.delayed(const Duration(seconds: 1), () {
      final replyText = 'Terima kasih pesan Anda! Tim marketing ${rxVendorName.value} akan segera membalas detail penawarannya. 🙏';
      
      messages.add(MessageModel(
        id: const Uuid().v4(),
        senderId: 'vendor',
        message: replyText,
        timestamp: DateTime.now(),
        isMe: false,
      ));

      _updateLastMessageInList(replyText);
    });
  }

  // Sinkronisasi teks obrolan terakhir ke halaman depan list
  void _updateLastMessageInList(String text) {
    final index = chatHistory.indexWhere((element) => element['vendor_id'] == activeVendorId.value);
    if (index != -1) {
      var updatedChat = Map<String, dynamic>.from(chatHistory[index]);
      updatedChat['last_message'] = text;
      updatedChat['time'] = 'Baru saja';
      chatHistory[index] = updatedChat;
    }
  }
}