// Data Models for HAJATO

// ─── Vendor Model ───────────────────────────────────────────────────────────────
class VendorModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> gallery;
  final List<ServicePackage> packages;
  final List<ReviewModel> reviews;
  final String location;
  final int startingPrice;
  final bool isFeatured;

  VendorModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    this.gallery = const [],
    this.packages = const [],
    this.reviews = const [],
    required this.location,
    required this.startingPrice,
    this.isFeatured = false,
  });
}

class ServicePackage {
  final String id;
  final String name;
  final String description;
  final int price;
  final List<String> features;

  ServicePackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
  });
}

class ReviewModel {
  final String id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final String date;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

// ─── Event Model ─────────────────────────────────────────────────────────────
class EventModel {
  final String id;
  String namaAcara;
  DateTime tanggal;
  String lokasi;
  String? description;

  EventModel({
    required this.id,
    required this.namaAcara,
    required this.tanggal,
    required this.lokasi,
    this.description,
  });
}

// ─── Guest Model ─────────────────────────────────────────────────────────────
class GuestModel {
  final String id;
  final String nama;
  final String nomorHP;
  bool hadir;
  bool checkedIn;
  final String? qrData;

  GuestModel({
    required this.id,
    required this.nama,
    required this.nomorHP,
    this.hadir = false,
    this.checkedIn = false,
    this.qrData,
  });
}

// ─── Booking Model ───────────────────────────────────────────────────────────
class BookingModel {
  final String id;
  final String vendorId;
  final String vendorName;
  final String packageId;
  final String packageName;
  DateTime bookingDate;
  String status; // pending, confirmed, cancelled
  final int totalPrice;

  BookingModel({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.packageId,
    required this.packageName,
    required this.bookingDate,
    required this.status,
    required this.totalPrice,
  });
}

// ─── Chat Message Model ───────────────────────────────────────────────────────
class MessageModel {
  final String id;
  final String senderId;
  final String message;
  final DateTime timestamp;
  final bool isMe;
  final MessageType type;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.message,
    required this.timestamp,
    required this.isMe,
    this.type = MessageType.text,
  });
}

enum MessageType { text, image, system }
