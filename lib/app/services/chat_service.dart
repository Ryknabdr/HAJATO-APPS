import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static String getChatId({
    required String userId,
    required String vendorId,
  }) {
    return '${userId}_$vendorId';
  }

  static Future<void> createOrUpdateChatRoom({
    required String chatId,
    required String userId,
    required String userName,
    required String vendorId,
    required String vendorName,
    required String lastMessage,
  }) async {
    await _firestore.collection('chats').doc(chatId).set(
      {
        'chat_id': chatId,
        'user_id': userId,
        'user_name': userName,
        'vendor_id': vendorId,
        'vendor_name': vendorName,
        'last_message': lastMessage,
        'updated_at': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  static Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderRole,
    required String message,
  }) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'sender_id': senderId,
      'sender_role': senderRole,
      'message': message,
      'image_url': '',
      'type': 'text',
      'created_at': FieldValue.serverTimestamp(),
    });

    await _updateChatRoomAfterMessage(
      chatId: chatId,
      senderRole: senderRole,
      lastMessage: message,
    );
  }

  static Future<void> sendImageMessage({
    required String chatId,
    required String senderId,
    required String senderRole,
    required String imageUrl,
  }) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'sender_id': senderId,
      'sender_role': senderRole,
      'message': '',
      'image_url': imageUrl,
      'type': 'image',
      'created_at': FieldValue.serverTimestamp(),
    });

    await _updateChatRoomAfterMessage(
      chatId: chatId,
      senderRole: senderRole,
      lastMessage: '📷 Gambar',
    );
  }

  static Future<void> _updateChatRoomAfterMessage({
    required String chatId,
    required String senderRole,
    required String lastMessage,
  }) async {
    await _firestore.collection('chats').doc(chatId).set(
      {
        'last_message': lastMessage,
        'last_sender_role': senderRole,
        'updated_at': FieldValue.serverTimestamp(),
        'unread_vendor':
            senderRole == 'user' ? FieldValue.increment(1) : 0,
        'unread_user':
            senderRole == 'vendor' ? FieldValue.increment(1) : 0,
      },
      SetOptions(merge: true),
    );
  }

  static Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('created_at', descending: false)
        .snapshots();
  }

  static Stream<QuerySnapshot> getVendorChats(String vendorId) {
    return _firestore
        .collection('chats')
        .where('vendor_id', isEqualTo: vendorId)
        .orderBy('updated_at', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getUnreadVendorChats(String vendorId) {
    return _firestore
        .collection('chats')
        .where('vendor_id', isEqualTo: vendorId)
        .snapshots();
  }

  static Future<void> markVendorChatAsRead(String chatId) async {
    await _firestore.collection('chats').doc(chatId).update({
      'unread_vendor': 0,
    });
  }
}