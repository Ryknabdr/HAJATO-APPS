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

class ChangePasswordView extends GetView<ProfileController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final oldPassCtrl     = TextEditingController();
    final newPassCtrl     = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    final formKey         = GlobalKey<FormState>();
    final showOld         = false.obs;
    final showNew         = false.obs;
    final showConfirm     = false.obs;

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Ganti Kata Sandi',
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
              // Info box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _kOrange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: _kOrange.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: _kOrange, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Gunakan minimal 6 karakter dengan kombinasi huruf dan angka.',
                        style: GoogleFonts.dmSans(
                            fontSize: 12, color: _kOrange, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _fieldLabel('Kata Sandi Lama'),
              Obx(() => _inputField(
                    controller: oldPassCtrl,
                    hint: 'Masukkan kata sandi lama',
                    icon: Icons.lock_outline_rounded,
                    obscure: !showOld.value,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                    suffix: GestureDetector(
                      onTap: () => showOld.value = !showOld.value,
                      child: Icon(
                        showOld.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFFB5B0A8),
                        size: 20,
                      ),
                    ),
                  )),
              const SizedBox(height: 16),

              _fieldLabel('Kata Sandi Baru'),
              Obx(() => _inputField(
                    controller: newPassCtrl,
                    hint: 'Minimal 6 karakter',
                    icon: Icons.lock_outline_rounded,
                    obscure: !showNew.value,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Wajib diisi';
                      if (v.length < 6) return 'Minimal 6 karakter';
                      return null;
                    },
                    suffix: GestureDetector(
                      onTap: () => showNew.value = !showNew.value,
                      child: Icon(
                        showNew.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFFB5B0A8),
                        size: 20,
                      ),
                    ),
                  )),
              const SizedBox(height: 16),

              _fieldLabel('Konfirmasi Kata Sandi Baru'),
              Obx(() => _inputField(
                    controller: confirmPassCtrl,
                    hint: 'Ulangi kata sandi baru',
                    icon: Icons.lock_outline_rounded,
                    obscure: !showConfirm.value,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Wajib diisi';
                      if (v != newPassCtrl.text) return 'Kata sandi tidak cocok';
                      return null;
                    },
                    suffix: GestureDetector(
                      onTap: () => showConfirm.value = !showConfirm.value,
                      child: Icon(
                        showConfirm.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFFB5B0A8),
                        size: 20,
                      ),
                    ),
                  )),
              const SizedBox(height: 32),

              _orangeButton(
                label: 'Ubah Kata Sandi',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    controller.changePassword(
                      oldPassword: oldPassCtrl.text,
                      newPassword: newPassCtrl.text,
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
      child: Text(text,
          style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: _kTextLight)),
    );

Widget _inputField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool obscure = false,
  String? Function(String?)? validator,
  Widget? suffix,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscure,
    validator: validator,
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
          borderSide: const BorderSide(color: _kBorder, width: 1.5)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: _kBorder, width: 1.5)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: _kOrange, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFE24B4A), width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFE24B4A), width: 1.5)),
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
              offset: const Offset(0, 6)),
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