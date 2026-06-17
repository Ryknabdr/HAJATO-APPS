// Data Models for HAJATO

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
  final String vendorUserId;

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
    required this.vendorUserId,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? '',
      vendorUserId: json['vendor_user_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      gallery: List<String>.from(json['gallery'] ?? []),
      packages: (json['packages'] as List? ?? [])
          .map((e) => ServicePackage.fromJson(e))
          .toList(),
      reviews: const [],
      location: json['location'] ?? '',
      startingPrice: json['starting_price'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
    );
  }
}
class ServicePackage {
  final String id;
  final String name;
  final String category;
  final String description;
  final int price;
  final String capacity;
  final String duration;
  final List<String> features;
  final String image;

  ServicePackage({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.capacity = '',
    this.duration = '',
    required this.features,
    this.image = '',
  });

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      capacity: json['capacity'] ?? '',
      duration: json['duration'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      image: json['image'] ?? '',
    );
  }
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

class BookingModel {
  final String id;
  final String customerName;
  final String vendorName;
  final String packageName;
  final String eventDate;
  final String eventTime;
  final String location;
  final String paymentMethod;
  final int totalPrice;
  final String bookingStatus;
  final String paymentStatus;
  final String vendorPayoutStatus;
  final String paymentProof;
  final bool hasReviewed;

  BookingModel({
    required this.id,
    required this.customerName,
    required this.vendorName,
    required this.packageName,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    required this.paymentMethod,
    required this.totalPrice,
    required this.bookingStatus,
    required this.paymentStatus,
    required this.vendorPayoutStatus,
    required this.paymentProof,
    required this.hasReviewed,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      customerName: json['customer_name'] ?? '',
      vendorName: json['vendor_name'] ?? '',
      packageName: json['package_name'] ?? '',
      eventDate: json['event_date'] ?? '',
      eventTime: json['event_time'] ?? '',
      location: json['location'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      totalPrice: json['total_price'] ?? 0,
      bookingStatus: json['booking_status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      vendorPayoutStatus: json['vendor_payout_status'] ?? '',
      paymentProof: json['payment_proof'] ?? '',
      hasReviewed: json['has_reviewed'] ?? false,
    );
  }
}
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

class VendorScheduleModel {
  final String id;
  final String customerName;
  final String packageName;
  final String eventDate;
  final String eventTime;
  final String location;
  final String bookingStatus;
  final String paymentStatus;
  final int totalPrice;

  VendorScheduleModel({
    required this.id,
    required this.customerName,
    required this.packageName,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    required this.bookingStatus,
    required this.paymentStatus,
    required this.totalPrice,
  });

  factory VendorScheduleModel.fromJson(Map<String, dynamic> json) {
    return VendorScheduleModel(
      id: json['id'] ?? '',
      customerName: json['customer_name'] ?? '',
      packageName: json['package_name'] ?? '',
      eventDate: json['event_date'] ?? '',
      eventTime: json['event_time'] ?? '',
      location: json['location'] ?? '',
      bookingStatus: json['booking_status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      totalPrice: json['total_price'] ?? 0,
    );
  }
}

class PayoutHistoryModel {
  final String id;
  final String customerName;
  final String packageName;
  final String eventDate;
  final int totalPrice;
  final String status;

  PayoutHistoryModel({
    required this.id,
    required this.customerName,
    required this.packageName,
    required this.eventDate,
    required this.totalPrice,
    required this.status,
  });

  factory PayoutHistoryModel.fromJson(Map<String, dynamic> json) {
    return PayoutHistoryModel(
      id: json['id'] ?? '',
      customerName: json['customer_name'] ?? '',
      packageName: json['package_name'] ?? '',
      eventDate: json['event_date'] ?? '',
      totalPrice: json['total_price'] ?? 0,
      status: json['vendor_payout_status'] ?? '',
    );
  }
}

class TopPackageModel {
  final String packageName;
  final int totalBooking;

  TopPackageModel({
    required this.packageName,
    required this.totalBooking,
  });

  factory TopPackageModel.fromJson(Map<String, dynamic> json) {
    return TopPackageModel(
      packageName: json['package_name'] ?? '',
      totalBooking: json['total_booking'] ?? 0,
    );
  }
}

enum MessageType { text, image, system }