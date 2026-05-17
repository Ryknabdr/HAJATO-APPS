import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/vendor_registration_controller.dart';
import '../../../core/theme/app_theme.dart';

class VendorRegistrationView extends GetView<VendorRegistrationController> {
  const VendorRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          const _BackgroundArt(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Obx(() => _buildStepContent()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (controller.currentStep.value == 0) {
                Get.back();
              } else {
                controller.prevStep();
              }
            },
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: Colors.white.withOpacity(0.2),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: Colors.white.withOpacity(0.2),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Center(child: Text('🏪', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 10),
            Text('HAJATO',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 20, fontWeight: FontWeight.w900,
                    color: Colors.white, letterSpacing: 1)),
          ]),
          const SizedBox(height: 16),
          Obx(() => Text(controller.stepTitle,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 26, fontWeight: FontWeight.w700,
                  color: Colors.white, height: 1.2))),
          const SizedBox(height: 4),
          Obx(() => Text(controller.stepSubtitle,
              style: GoogleFonts.dmSans(
                  fontSize: 13, color: Colors.white.withOpacity(0.7)))),
          const SizedBox(height: 16),
          Obx(() => _StepIndicator(
            total: controller.totalSteps,
            currentStep: controller.currentStep.value,
          )),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 40, offset: Offset(0, -10))
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 36, height: 3,
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: _currentStepWidget(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _currentStepWidget() {
    switch (controller.currentStep.value) {
      case 0: return _Step1Business();
      case 1: return _Step2Identity();
      case 2: return _Step3Documents();
      case 3: return _Step4Review();
      default: return const SizedBox();
    }
  }

  Widget _buildBottomBar() {
    return Obx(() {
      final isLast    = controller.currentStep.value == controller.totalSteps - 1;
      final isLoading = controller.isLoading.value;
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, -4))
          ],
        ),
        child: _PrimaryButton(
          label: isLast ? 'Kirim Pendaftaran' : 'Lanjutkan',
          isLoading: isLoading,
          disabled: isLoading,
          onTap: isLast ? controller.submit : controller.nextStep,
          icon: isLast ? Icons.send_rounded : Icons.arrow_forward_rounded,
        ),
      );
    });
  }
}

// ─── Step 1 ───────────────────────────────────────────────────────────────────

class _Step1Business extends GetView<VendorRegistrationController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Nama Bisnis'),
          const SizedBox(height: 8),
          _InputField(
            controller: controller.businessNameController,
            hint: 'Contoh: Foto Studio Bahagia',
            icon: Icons.storefront_outlined,
            textCapitalization: TextCapitalization.words,
            validator: controller.validateBusinessName,
          ),
          const SizedBox(height: 16),
          const _FieldLabel('Kategori'),
          const SizedBox(height: 8),
          Obx(() => _CategoryDropdown(
            value: controller.selectedCategory.value.isEmpty
                ? null : controller.selectedCategory.value,
            items: controller.categories,
            onChanged: (v) => controller.selectedCategory.value = v ?? '',
          )),
          const SizedBox(height: 16),
          const _FieldLabel('Deskripsi Bisnis'),
          const SizedBox(height: 8),
          _InputField(
            controller: controller.businessDescController,
            hint: 'Ceritakan layanan yang Anda tawarkan...',
            icon: Icons.description_outlined,
            maxLines: 4,
            validator: controller.validateDescription,
          ),
          const SizedBox(height: 16),
          const _FieldLabel('Lokasi / Kota'),
          const SizedBox(height: 8),
          _InputField(
            controller: controller.businessLocationController,
            hint: 'Contoh: Jakarta Selatan',
            icon: Icons.location_on_outlined,
            validator: controller.validateLocation,
          ),
          const SizedBox(height: 16),
          const _FieldLabel('Nomor HP Bisnis'),
          const SizedBox(height: 8),
          _InputField(
            controller: controller.businessPhoneController,
            hint: '08xxxxxxxxxx',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: controller.validatePhone,
          ),
          const SizedBox(height: 24),

          // ── Divider Akun Vendor ──────────────────────────────────────────
          Row(children: [
            Expanded(child: Divider(color: const Color(0xFFB2DFDB), thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('Akun Vendor',
                  style: GoogleFonts.dmSans(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      letterSpacing: 0.8, color: AppColors.textSecondary)),
            ),
            Expanded(child: Divider(color: const Color(0xFFB2DFDB), thickness: 1)),
          ]),
          const SizedBox(height: 16),

          const _FieldLabel('Email'),
          const SizedBox(height: 8),
          _InputField(
            controller: controller.emailController,
            hint: 'contoh@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),
          const SizedBox(height: 16),
          const _FieldLabel('Password'),
          const SizedBox(height: 8),
          Obx(() => _InputField(
            controller: controller.passwordController,
            hint: 'Min. 8 karakter, huruf kapital & angka',
            icon: Icons.lock_outline_rounded,
            obscureText: !controller.isPasswordVisible.value,
            validator: controller.validatePassword,
            suffix: GestureDetector(
              onTap: () => controller.isPasswordVisible.toggle(),
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: AppColors.primary.withOpacity(0.6),
                ),
              ),
            ),
          )),
          const SizedBox(height: 16),
          const _FieldLabel('Konfirmasi Password'),
          const SizedBox(height: 8),
          Obx(() => _InputField(
            controller: controller.confirmPasswordController,
            hint: 'Ulangi password Anda',
            icon: Icons.lock_outline_rounded,
            obscureText: !controller.isConfirmPasswordVisible.value,
            validator: controller.validateConfirmPassword,
            suffix: GestureDetector(
              onTap: () => controller.isConfirmPasswordVisible.toggle(),
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  controller.isConfirmPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: AppColors.primary.withOpacity(0.6),
                ),
              ),
            ),
          )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Step 2 ───────────────────────────────────────────────────────────────────

class _Step2Identity extends GetView<VendorRegistrationController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Nama Sesuai KTP'),
          const SizedBox(height: 8),
          _InputField(
            controller: controller.ownerNameController,
            hint: 'Nama lengkap sesuai KTP',
            icon: Icons.badge_outlined,
            textCapitalization: TextCapitalization.words,
            validator: controller.validateOwnerName,
          ),
          const SizedBox(height: 16),
          const _FieldLabel('NIK (Nomor Induk Kependudukan)'),
          const SizedBox(height: 8),
          _InputField(
            controller: controller.ownerNikController,
            hint: '16 digit nomor KTP',
            icon: Icons.numbers_rounded,
            keyboardType: TextInputType.number,
            validator: controller.validateNik,
          ),
          const SizedBox(height: 20),

          // ── KTP Upload + Preview ─────────────────────────────────────────
          const _FieldLabel('Foto KTP'),
          const SizedBox(height: 8),
          Obx(() => _UploadBox(
            label: 'Upload Foto KTP',
            sublabel: 'Pastikan semua tulisan terbaca jelas',
            icon: Icons.credit_card_rounded,
            imageFile: controller.ktpImageFile.value,
            isLoading: controller.isPickingKtp.value,
            errorText: controller.ktpError.value,
            onTap: controller.isPickingKtp.value ? null : controller.pickKtpImage,
          )),
          const SizedBox(height: 16),

          // ── Selfie Upload + Preview ──────────────────────────────────────
          const _FieldLabel('Selfie dengan KTP'),
          const SizedBox(height: 8),
          Obx(() => _UploadBox(
            label: 'Upload Selfie + KTP',
            sublabel: 'Foto wajah Anda sambil memegang KTP',
            icon: Icons.camera_front_rounded,
            imageFile: controller.selfieImageFile.value,
            isLoading: controller.isPickingSelfie.value,
            errorText: controller.selfieError.value,
            onTap: controller.isPickingSelfie.value ? null : controller.pickSelfieImage,
          )),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Data identitas Anda dienkripsi dan hanya digunakan untuk proses verifikasi.',
                    style: GoogleFonts.dmSans(
                        fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 3 ───────────────────────────────────────────────────────────────────

class _Step3Documents extends GetView<VendorRegistrationController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              const Icon(Icons.stars_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Dokumen ini bersifat opsional namun meningkatkan kepercayaan pelanggan.',
                  style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white, height: 1.5),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          const _FieldLabel('NPWP (Opsional)'),
          const SizedBox(height: 8),
          _InputField(
            controller: controller.npwpController,
            hint: 'Nomor NPWP bisnis Anda',
            icon: Icons.receipt_long_outlined,
            keyboardType: TextInputType.number,
            validator: controller.validateNpwp,
          ),
          const SizedBox(height: 16),
          const _FieldLabel('Izin Usaha / SIUP (Opsional)'),
          const SizedBox(height: 8),
          Obx(() => _UploadBox(
            label: 'Upload Dokumen Izin',
            sublabel: 'SIUP, TDP, atau surat keterangan usaha',
            icon: Icons.folder_outlined,
            imageFile: controller.businessLicenseFile.value,
            isLoading: controller.isPickingLicense.value,
            onTap: controller.isPickingLicense.value ? null : controller.pickBusinessLicense,
          )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Step 4 ───────────────────────────────────────────────────────────────────

class _Step4Review extends GetView<VendorRegistrationController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReviewSection('Informasi Bisnis', [
          _ReviewRow('Nama Bisnis', controller.businessNameController.text),
          _ReviewRow('Kategori', controller.selectedCategory.value),
          _ReviewRow('Lokasi', controller.businessLocationController.text),
          _ReviewRow('No. HP', controller.businessPhoneController.text),
          _ReviewRow('Deskripsi', controller.businessDescController.text),
        ]),
        const SizedBox(height: 16),
        _ReviewSection('Akun Vendor', [
          _ReviewRow('Email', controller.emailController.text),
          const _ReviewRow('Password', '••••••••'),
        ]),
        const SizedBox(height: 16),
        _ReviewSection('Identitas Pemilik', [
          _ReviewRow('Nama', controller.ownerNameController.text),
          _ReviewRow('NIK', controller.ownerNikController.text),
          _ReviewRow('Foto KTP',
              controller.ktpImageFile.value != null ? '✓ Terupload' : '-'),
          _ReviewRow('Selfie + KTP',
              controller.selfieImageFile.value != null ? '✓ Terupload' : '-'),
        ]),
        const SizedBox(height: 16),
        _ReviewSection('Dokumen Pendukung', [
          _ReviewRow('NPWP',
              controller.npwpController.text.isEmpty
                  ? 'Tidak dilampirkan' : controller.npwpController.text),
          _ReviewRow('Izin Usaha',
              controller.businessLicenseFile.value == null
                  ? 'Tidak dilampirkan' : '✓ Terupload'),
        ]),
        const SizedBox(height: 16),

        // ── Image Previews di Review ─────────────────────────────────────
        if (controller.ktpImageFile.value != null ||
            controller.selfieImageFile.value != null) ...[
          Text('Pratinjau Dokumen',
              style: GoogleFonts.dmSans(
                  fontSize: 13, fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
          const SizedBox(height: 10),
          Row(children: [
            if (controller.ktpImageFile.value != null)
              Expanded(
                child: _ImagePreviewCard(
                  label: 'KTP',
                  file: controller.ktpImageFile.value!,
                ),
              ),
            if (controller.ktpImageFile.value != null &&
                controller.selfieImageFile.value != null)
              const SizedBox(width: 10),
            if (controller.selfieImageFile.value != null)
              Expanded(
                child: _ImagePreviewCard(
                  label: 'Selfie + KTP',
                  file: controller.selfieImageFile.value!,
                ),
              ),
          ]),
          const SizedBox(height: 16),
        ],

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.accent.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Icon(Icons.schedule_rounded, color: AppColors.accent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimasi Verifikasi',
                        style: GoogleFonts.dmSans(
                            fontSize: 13, fontWeight: FontWeight.w600,
                            color: AppColors.accent)),
                    const SizedBox(height: 2),
                    Text('1-3 hari kerja setelah data diterima',
                        style: GoogleFonts.dmSans(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Status View ──────────────────────────────────────────────────────────────

class VendorRegistrationStatusView extends StatelessWidget {
  const VendorRegistrationStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 24, offset: const Offset(0, 8)),
                  ],
                ),
                child: const Icon(Icons.hourglass_top_rounded,
                    color: Colors.white, size: 48),
              ),
              const SizedBox(height: 28),
              Text('Pendaftaran Terkirim!',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 26, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              Text(
                'Tim Hajato sedang meninjau data Anda.\nProses verifikasi membutuhkan 1–3 hari kerja.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                    fontSize: 14, color: AppColors.textSecondary, height: 1.6),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🟡', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Text('Menunggu Verifikasi',
                        style: GoogleFonts.dmSans(
                            fontSize: 14, fontWeight: FontWeight.w600,
                            color: AppColors.accentDark)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _PrimaryButton(
                label: 'Kembali ke Beranda',
                isLoading: false,
                disabled: false,
                onTap: () => Get.offAllNamed('/home'),
                icon: Icons.home_rounded,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Get.back(),
                child: Text('Lihat Status Pendaftaran',
                    style: GoogleFonts.dmSans(
                        fontSize: 13, color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _BackgroundArt extends StatelessWidget {
  const _BackgroundArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: CustomPaint(painter: _BgPainter()),
    );
  }
}

class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    _orb(canvas, Offset(size.width + 40, -60), 200,
        Colors.white.withOpacity(0.15));
    _orb(canvas, Offset(-30, size.height - 20), 140,
        Colors.white.withOpacity(0.10));

    final grid = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  void _orb(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawCircle(c, r,
        Paint()
          ..shader = RadialGradient(colors: [color, Colors.transparent])
              .createShader(Rect.fromCircle(center: c, radius: r)));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _StepIndicator extends StatelessWidget {
  final int total;
  final int currentStep;
  const _StepIndicator({required this.total, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final isDone   = i < currentStep;
        final isActive = i == currentStep;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDone || isActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (i < total - 1) const SizedBox(width: 4),
            ],
          ),
        );
      }),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.dmSans(
            fontSize: 11, fontWeight: FontWeight.w600,
            letterSpacing: 0.8, color: AppColors.textSecondary),
      );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.suffix,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      maxLines: obscureText ? 1 : maxLines,
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
}

class _CategoryDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _CategoryDropdown(
      {required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFB2DFDB), width: 1.5),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.category_outlined,
              size: 18, color: AppColors.primary.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          hintText: 'Pilih kategori',
          hintStyle: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textHint),
        ),
        items: items
            .map((c) => DropdownMenuItem(
                value: c,
                child: Text(c,
                    style: GoogleFonts.dmSans(
                        fontSize: 14, color: AppColors.textPrimary))))
            .toList(),
      ),
    );
  }
}

// ─── Upload Box (with preview, loading, error) ────────────────────────────────

class _UploadBox extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final File? imageFile;
  final bool isLoading;
  final String? errorText;
  final VoidCallback? onTap;

  const _UploadBox({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.imageFile,
    this.isLoading = false,
    this.errorText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage  = imageFile != null;
    final hasError  = errorText != null && errorText!.isNotEmpty;
    final disabled  = isLoading || onTap == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: disabled ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            decoration: BoxDecoration(
              color: hasError
                  ? AppColors.error.withOpacity(0.04)
                  : hasImage
                      ? AppColors.primary.withOpacity(0.05)
                      : AppColors.surface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: hasError
                    ? AppColors.error
                    : hasImage
                        ? AppColors.primary
                        : const Color(0xFFB2DFDB),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // ── Header row ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: hasError
                            ? AppColors.error.withOpacity(0.1)
                            : hasImage
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : Icon(
                              hasError
                                  ? Icons.error_outline_rounded
                                  : hasImage
                                      ? Icons.check_circle_rounded
                                      : icon,
                              color: hasError
                                  ? AppColors.error
                                  : hasImage
                                      ? AppColors.primary
                                      : AppColors.textHint,
                              size: 22,
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLoading
                                ? 'Memproses...'
                                : hasImage
                                    ? 'Berhasil diupload'
                                    : label,
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: hasError
                                  ? AppColors.error
                                  : hasImage
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hasImage ? 'Ketuk untuk mengganti' : sublabel,
                            style: GoogleFonts.dmSans(
                                fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (!isLoading)
                      Icon(
                        hasImage ? Icons.edit_outlined : Icons.upload_rounded,
                        color: hasImage ? AppColors.primary : AppColors.textHint,
                        size: 18,
                      ),
                  ]),
                ),

                // ── Image Preview ───────────────────────────────────────────
                if (hasImage && !isLoading) ...[
                  const Divider(height: 1, color: Color(0xFFB2DFDB)),
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12)),
                    child: Image.file(
                      imageFile!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // ── Error Text ────────────────────────────────────────────────────
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 13, color: AppColors.error),
              const SizedBox(width: 4),
              Text(
                errorText!,
                style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ─── Image Preview Card (untuk Step 4 Review) ────────────────────────────────

class _ImagePreviewCard extends StatelessWidget {
  final String label;
  final File file;

  const _ImagePreviewCard({required this.label, required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB2DFDB), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(11)),
            child: Image.file(
              file,
              width: double.infinity,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 5),
                Text(label,
                    style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Review Section / Row ─────────────────────────────────────────────────────

class _ReviewSection extends StatelessWidget {
  final String title;
  final List<_ReviewRow> rows;
  const _ReviewSection(this.title, this.rows);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2DFDB)),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.05),
              blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(title,
                style: GoogleFonts.dmSans(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
          const Divider(height: 1, color: Color(0xFFB2DFDB)),
          ...rows.map((r) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(r.label,
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: AppColors.textSecondary)),
                ),
                Expanded(
                  child: Text(
                    r.value.isEmpty ? '-' : r.value,
                    style: GoogleFonts.dmSans(
                        fontSize: 12, fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}

class _ReviewRow {
  final String label;
  final String value;
  const _ReviewRow(this.label, this.value);
}

// ─── Primary Button ───────────────────────────────────────────────────────────

class _PrimaryButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final bool disabled;
  final VoidCallback onTap;
  final IconData? icon;

  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.disabled,
    required this.onTap,
    this.icon,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.disabled
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onTap();
            },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: widget.disabled ? 0.6 : 1.0,
          child: Container(
            width: double.infinity, height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: widget.disabled
                  ? LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.5),
                        AppColors.primary.withOpacity(0.5),
                      ],
                    )
                  : AppColors.primaryGradient,
              boxShadow: widget.disabled
                  ? []
                  : [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8)),
                    ],
            ),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                        ],
                        Text(widget.label,
                            style: GoogleFonts.dmSans(
                                fontSize: 15, fontWeight: FontWeight.w600,
                                color: Colors.white, letterSpacing: 0.3)),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}