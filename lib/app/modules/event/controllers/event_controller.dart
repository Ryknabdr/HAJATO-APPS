import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';

class EventController extends GetxController {
  final namaAcara = ''.obs;
  final tanggal = Rx<DateTime?>(null);
  final lokasi = ''.obs;
  final currentEvent = Rx<EventModel?>(null);
  final invitationLink = ''.obs;

  String get formattedDate =>
      tanggal.value == null ? 'Pilih tanggal' : DateFormat('dd MMMM yyyy', 'id').format(tanggal.value!);

  void setNama(String v) => namaAcara.value = v;
  void setLokasi(String v) => lokasi.value = v;

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF4F6AF5)),
        ),
        child: child!,
      ),
    );
    if (picked != null) tanggal.value = picked;
  }

  void saveEvent() {
    if (namaAcara.value.isEmpty || tanggal.value == null || lokasi.value.isEmpty) {
      Get.snackbar('Peringatan', 'Harap isi semua data acara',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFBBF24));
      return;
    }
    currentEvent.value = EventModel(
      id: const Uuid().v4(),
      namaAcara: namaAcara.value,
      tanggal: tanggal.value!,
      lokasi: lokasi.value,
    );
    invitationLink.value = 'https://hajato.app/rsvp/${currentEvent.value!.id}';
    Get.toNamed(AppRoutes.invitation);
  }
}
