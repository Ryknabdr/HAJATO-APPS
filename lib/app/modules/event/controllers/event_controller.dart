import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import 'package:hajato/app/core/constants/api_config.dart';

class EventController extends GetxController {
  // ── 1. TEXT EDITING CONTROLLERS ─────────────────────────────────────
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController descController;
  late TextEditingController bankController;

  // Variabel state pendukung
  final namaAcara = ''.obs;
  final lokasi = ''.obs;
  final deskripsi = ''.obs;
  final nomorRekening = ''.obs;

  final tanggal = Rx<DateTime?>(null);
  final isLoading = false.obs; 

  // Kategori dropdown dinamis: 'wedding', 'khitanan', atau 'formal'
  final selectedCategory = 'wedding'.obs;

  // Pilihan template tema undangan digital
  final selectedTemplate = 'template_1'.obs;

  // ── 2. VARIABEL FITUR DINAMIS (RUNDOWN & GALERI MEMPELAI) ────────────
  final rundownList = <RundownItem>[].obs;
  final galleryFiles = <XFile>[].obs; 
  final ImagePicker _picker = ImagePicker();

  // ── 3. VARIABEL MODEL & SELESAI ACARA ──────────────────────────────
  final currentEvent = Rx<EventModel?>(null);
  final invitationLink = ''.obs;

  // ── 4. GETTER FORMATTING ───────────────────────────────────────────
  String get formattedDate =>
      tanggal.value == null ? 'Pilih tanggal' : DateFormat('dd MMMM yyyy', 'id').format(tanggal.value!);

  // ── 5. LIFECYCLE INITIALIZATION ─────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    locationController = TextEditingController();
    descController = TextEditingController();
    bankController = TextEditingController();

    nameController.addListener(() => namaAcara.value = nameController.text);
    locationController.addListener(() => lokasi.value = locationController.text);
    deskripsi.value = descController.text;
    bankController.addListener(() => nomorRekening.value = bankController.text);

    _loadSavedEventId();
  }

  @override
  void onClose() {
    nameController.dispose();
    locationController.dispose();
    descController.dispose();
    bankController.dispose();
    super.onClose();
  }

  Future<void> _loadSavedEventId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedEventJson = prefs.getString('last_active_event_data');
      String? savedLink = prefs.getString('last_active_invitation_link');
      
      if (savedEventJson != null && savedEventJson.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(savedEventJson);
        currentEvent.value = EventModel.fromJson(decoded);
        invitationLink.value = savedLink ?? '';

        nameController.text = currentEvent.value?.namaAcara ?? '';
        locationController.text = currentEvent.value?.lokasi ?? '';
        
        print("[DEBUG HAJATO] AUTO-LOAD ACTIVE EVENT ID FROM STORAGE: ${currentEvent.value!.id}");
      }
    } catch (e) {
      print("[DEBUG HAJATO] GAGAL AUTO-LOAD EVENT ID: $e");
    }
  }

  // ── 6. SETTER LOGIK MANUAL ─────────────────────────────────────────
  void setNama(String v) => namaAcara.value = v;
  void setLokasi(String v) => lokasi.value = v;
  void setDeskripsi(String v) => deskripsi.value = v;
  void setRekening(String v) => nomorRekening.value = v;
  void selectTemplate(String templateName) => selectedTemplate.value = templateName;

  // ── 7. LOGIK MANAGER RUNDOWN ACARA ──────────────────────────────────
  void addRundownItem(String time, String activity) {
    rundownList.add(RundownItem(time: time, activity: activity));
  }

  void removeRundownItem(int index) {
    if (index >= 0 && index < rundownList.length) {
      rundownList.removeAt(index);
    }
  }

  // ── 8. LOGIK PICKER MEDIA FOTO GALERI ────────────────────────────────
  Future<void> pickGalleryImage() async {
    try {
      int maxAllowed = selectedCategory.value == 'wedding' ? 2 : 1;
      final int maxImages = maxAllowed - galleryFiles.length;
      
      if (maxImages <= 0) {
        String msg = selectedCategory.value == 'wedding' 
            ? 'Maksimal upload adalah 2 foto mempelai' 
            : 'Maksimal upload adalah 1 foto anak';
        Get.snackbar('Informasi', msg,
            snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFF3B82F6), colorText: Colors.white);
        return;
      }

      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 70, 
      );
      
      if (pickedFiles.isNotEmpty) {
        galleryFiles.addAll(pickedFiles.take(maxImages));
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil gambar: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void removeGalleryFile(int index) {
    if (index >= 0 && index < galleryFiles.length) {
      galleryFiles.removeAt(index);
    }
  }

  // ── 9. DATE PICKER DIALOG HANDLER ──────────────────────────────────
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

  // ── 10. LOGIK SIMPAN UTAMA DENGAN UPDATE KEY EVENT ID REAL-TIME ──
  Future<void> saveEvent() async {
    if (nameController.text.trim().isEmpty || tanggal.value == null || locationController.text.trim().isEmpty) {
      Get.snackbar('Peringatan', 'Harap isi semua data utama acara',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFFFBBF24));
      return;
    }

    if (selectedCategory.value == 'formal' && descController.text.trim().isEmpty) {
      descController.text = "Agenda resmi acara umum / webinar.";
    }

    if (selectedCategory.value == 'wedding' && galleryFiles.length < 2) {
      Get.snackbar('Peringatan', 'Harap pilih 2 foto untuk kedua mempelai',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFFFBBF24));
      return;
    }
    
    if (selectedCategory.value == 'khitanan' && galleryFiles.isEmpty) {
      Get.snackbar('Peringatan', 'Harap pilih 1 foto terbaik anak khitan',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFFFBBF24));
      return;
    }

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      String formattedDateStr = DateFormat('yyyy-MM-dd').format(tanggal.value!);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/api/events/create'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = nameController.text.trim();
      request.fields['date'] = formattedDateStr;
      request.fields['time'] = "09:00";
      request.fields['location'] = locationController.text.trim();
      request.fields['description'] = descController.text.trim();
      request.fields['rekening'] = bankController.text.isEmpty ? '-' : bankController.text.trim();
      request.fields['template'] = selectedTemplate.value;
      request.fields['category'] = selectedCategory.value; 
      
      request.fields['rundown'] = jsonEncode(rundownList.map((e) => e.toJson()).toList());

      for (var i = 0; i < galleryFiles.length; i++) {
        var file = galleryFiles[i];
        String ext = path.extension(file.path).replaceFirst('.', '').toLowerCase();
        if (ext.isEmpty) ext = 'jpeg';
        
        var multipartFile = await http.MultipartFile.fromPath(
          'gallery', 
          file.path,
          contentType: MediaType('image', ext == 'png' ? 'png' : 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['status'] == 'success') {
        final eventData = responseData['data'];
        currentEvent.value = EventModel.fromJson(eventData);
        
        // ── 🟢 EXTRACTION ID LANGSUNG MENGHINDARI SALAH PEMETAAN MODEL ──
        String serverEventId = eventData['_id'] ?? eventData['id'] ?? '';
        
        invitationLink.value = '${ApiConfig.baseUrl}/api/events/rsvp/$serverEventId';
        
        await prefs.setString('last_active_event_data', jsonEncode(eventData));
        await prefs.setString('last_active_invitation_link', invitationLink.value);

        // ── 🟢 SIMPAN KE KEY UTAMA AGAR TERBACA OLEH DASHBOARD CONTROLLER ──
        await prefs.setString('selected_event_id', serverEventId);
        print("[DEBUG HAJATO] FIX UPDATE selected_event_id LANGSUNG: $serverEventId");

        Get.snackbar('Sukses', 'Undangan Digital berhasil dibuat!',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);

        Get.toNamed(AppRoutes.invitation);

        galleryFiles.clear();
        rundownList.clear();
      } else {
        Get.snackbar('Gagal', responseData['message'] ?? 'Terjadi kesalahan server',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Tidak dapat terhubung ke server: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ── 11. FITUR BAGIKAN LINK UNDANGAN ──────────────────────────────────
  void shareToPlatform(String platform) {
    final nama = currentEvent.value?.namaAcara ?? namaAcara.value;
    final tgl = formattedDate;
    final tempat = currentEvent.value?.lokasi ?? lokasi.value;
    final link = invitationLink.value;

    final String message = 
        "Halo! Anda diundang ke acara *$nama*.\n\n"
        "📅 *Tanggal:* $tgl\n"
        "📍 *Lokasi:* $tempat\n\n"
        "Link RSVP:\n$link";

    if (platform == 'WhatsApp' || platform == 'Email' || platform == 'Lainnya') {
      Share.share(message, subject: 'Undangan Digital: $nama');
    } else if (platform == 'Instagram') {
      Clipboard.setData(ClipboardData(text: link));
      Get.snackbar('Link Disalin', 'Link undangan berhasil disalin!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFFE1306C), colorText: Colors.white);
    }
  }

  // ── 12. FUNGSI CLEANER FORM UTAMA ────────────────────────────────────
  void clearEventForm() async {
    nameController.clear();
    locationController.clear();
    descController.clear();
    bankController.clear();
    
    namaAcara.value = '';
    lokasi.value = '';
    deskripsi.value = '';
    nomorRekening.value = '';
    tanggal.value = null;
    selectedTemplate.value = 'template_1';
    selectedCategory.value = 'wedding';
    currentEvent.value = null;
    invitationLink.value = '';
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_active_event_data');
    await prefs.remove('last_active_invitation_link');
    await prefs.remove('selected_event_id'); // Pastikan ikut terhapus di form cleaner
  }
}