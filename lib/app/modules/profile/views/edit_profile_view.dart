import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';

const _kOrange      = Color(0xFFFF6B2C);
const _kOrangeDark  = Color(0xFFD94F10);
const _kOrangeLight = Color(0xFFFF9A5C);
const _kBg          = Color(0xFFFFF8F5);
const _kTextDark    = Color(0xFF18130A);
const _kTextLight   = Color(0xFF8A8278);
const _kBorder      = Color(0xFFEDE9E1);

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl  = TextEditingController(text: controller.name.value);
    final phoneCtrl = TextEditingController(text: controller.phone.value);
    final bioCtrl   = TextEditingController(text: controller.bio.value);
    final formKey   = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Edit Profil',
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Obx(() => Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [_kOrangeLight, _kOrangeDark],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _kOrange.withOpacity(0.3),
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
                        )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _kOrange,
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

              _orangeButton(
                label: 'Simpan Perubahan',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    controller.updateProfile(
                      newName: nameCtrl.text.trim(),
                      newPhone: phoneCtrl.text.trim(),
                      newBio: bioCtrl.text.trim(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _fieldLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: _kTextLight,
        ),
      ),
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
    style: GoogleFonts.dmSans(fontSize: 14, color: _kTextDark),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.dmSans(fontSize: 14, color: const Color(0xFFC0BBB5)),
      prefixIcon: Icon(icon, size: 18, color: _kOrange.withOpacity(0.6)),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: _kBorder, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: _kBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: _kOrange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE24B4A), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE24B4A), width: 1.5),
      ),
    ),
  );
}

Widget _orangeButton({required String label, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [_kOrangeLight, _kOrangeDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _kOrange.withOpacity(0.35),
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