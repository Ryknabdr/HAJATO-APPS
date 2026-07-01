import 'dart:io'; // Diperlukan untuk handle file gambar lokal

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Diperlukan untuk source media pengambilan gambar
import '../controllers/profile_controller.dart';
import '../../../core/theme/app_theme.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl  = TextEditingController(text: controller.name.value);
    final phoneCtrl = TextEditingController(text: controller.phone.value);
    final bioCtrl   = TextEditingController(text: controller.bio.value);
    final formKey   = GlobalKey<FormState>();
    
    // Objek Rx lokal opsional untuk menampung file gambar yang baru dipilih secara lokal
    final selectedImage = Rxn<File>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Edit Profil',
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      // Menggunakan Obx di paling luar body agar loading overlay ter-render otomatis saat update berjalan
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- AREA FOTO PROFIL ---
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        // Membuka galeri melalui fungsi pickImage yang ada di controller
                        final File? image = await controller.pickImage(ImageSource.gallery);
                        if (image != null) {
                          selectedImage.value = image; // Simpan ke state lokal untuk pratinjau UI
                        }
                      },
                      child: Stack(
                        children: [
                          Obx(() {
                            // Kondisi 1: Jika ada gambar baru yang dipilih dari lokal
                            if (selectedImage.value != null) {
                              return Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: FileImage(selectedImage.value!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            } 
                            // Kondisi 2: Jika gambar lokal kosong tapi ada URL foto profil dari server
                            else if (controller.avatarUrl.value.isNotEmpty) {
                              return Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(controller.avatarUrl.value),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            } 
                            // Kondisi 3: Jika tidak ada foto sama sekali, tampilkan inisial huruf nama
                            else {
                              return Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.primaryGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.35),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    controller.name.value.isNotEmpty
                                        ? controller.name.value[0].toUpperCase()
                                        : '?',
                                    style: GoogleFonts.playfairDisplay(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          }),
                          // Icon Kamera Kecil di Pojok Kanan Bawah Foto
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt_rounded,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _fieldLabel('Nama Lengkap'),
                  _inputField(
                    controller: nameCtrl,
                    hint: 'Nama lengkap Anda',
                    icon: Icons.person_outline_rounded,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Nama tidak boleh kosong';
                      if (v.trim().length < 3) return 'Nama minimal 3 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _fieldLabel('Nomor HP'),
                  _inputField(
                    controller: phoneCtrl,
                    hint: '08xxxxxxxxxx',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Nomor HP tidak boleh kosong';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _fieldLabel('Bio'),
                  _inputField(
                    controller: bioCtrl,
                    hint: 'Ceritakan tentang diri Anda...',
                    icon: Icons.edit_note_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  _primaryButton(
                    label: 'Simpan Perubahan',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        // Mengirimkan semua data termasuk data file gambar (jika ada) ke controller
                        controller.updateProfile(
                          newName: nameCtrl.text.trim(),
                          newPhone: phoneCtrl.text.trim(),
                          newBio: bioCtrl.text.trim(),
                          imageFile: selectedImage.value,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Layer Loading Overlay untuk memblokir interaksi user saat proses upload/stream request
          if (controller.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.25),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      )),
    );
  }
}

Widget _fieldLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: AppColors.textSecondary)),
    );

Widget _inputField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool obscure = false,
  TextInputType? keyboardType,
  TextCapitalization textCapitalization = TextCapitalization.none,
  String? Function(String?)? validator,
  Widget? suffix,
  int maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    validator: validator,
    maxLines: maxLines,
    style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textPrimary),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textHint),
      prefixIcon: Icon(icon, size: 18, color: AppColors.primary.withOpacity(0.6)),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFB2DFDB), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFB2DFDB), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
    ),
  );
}

Widget _primaryButton({required String label, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Text(label,
            style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.3)),
      ),
    ),
  );
}