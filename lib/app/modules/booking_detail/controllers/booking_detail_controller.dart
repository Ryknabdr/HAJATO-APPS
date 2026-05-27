import 'package:get/get.dart';

import '../../../data/models/models.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_config.dart';

class BookingDetailController extends GetxController {

  late BookingModel booking;
  final selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();

    booking = Get.arguments as BookingModel;
  }

  Future<void> pickPaymentProof() async {
  final picker = ImagePicker();

  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (picked != null) {
    selectedImage.value = File(picked.path);
  }
}

Future<void> uploadPaymentProof() async {

  if (selectedImage.value == null) {

    Get.snackbar(
      'Peringatan',
      'Pilih gambar terlebih dahulu',
    );

    return;
  }

  try {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '${ApiConfig.baseUrl}/api/booking/upload-proof/${booking.id}',
      ),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        selectedImage.value!.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {

      Get.snackbar(
        'Berhasil',
        'Bukti pembayaran berhasil diupload',
      );

    } else {

      Get.snackbar(
        'Error',
        'Upload gagal',
      );
    }

  } catch (e) {

    print('UPLOAD ERROR: $e');
  }
}
}