import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/register_controller.dart';

const _kOrange = Color(0xFFFF6B2C);
const _kOrangeDark = Color(0xFFD94F10);
const _kOrangeLight = Color(0xFFFF9A5C);

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kOrange,
      body: Stack(
        children: [
          const _BackgroundArt(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const _Header(),
                  const _FormPanel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Background (sama persis dengan LoginView) ───────────────────────────────

class _BackgroundArt extends StatelessWidget {
  const _BackgroundArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
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
        colors: [Color(0xFFFF8C42), Color(0xFFD94F10)],
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
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [color, Colors.transparent],
          ).createShader(Rect.fromCircle(center: c, radius: r)));
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: Colors.white.withOpacity(0.2),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Center(
                  child: Text('🎊', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'HAJATO',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: GoogleFonts.playfairDisplay(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
                letterSpacing: -0.5,
              ),
              children: [
                const TextSpan(text: 'Buat Akun\n'),
                TextSpan(
                  text: 'Baru',
                  style: TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(1, 1),
                        blurRadius: 4,
                      ),
                    ],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Daftar sekarang dan mulai rencanakan hajatan impian Anda',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Form Panel ──────────────────────────────────────────────────────────────

class _FormPanel extends GetView<RegisterController> {
  const _FormPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 40,
            offset: Offset(0, -10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // drag handle
            Center(
              child: Container(
                width: 36,
                height: 3,
                margin: const EdgeInsets.only(bottom: 28),
                decoration: BoxDecoration(
                  color: _kOrange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Nama Lengkap ──
            const _FieldLabel('Nama Lengkap'),
            const SizedBox(height: 8),
            _InputField(
              controller: controller.nameController,
              hint: 'Nama lengkap Anda',
              icon: Icons.person_outline_rounded,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              validator: controller.validateName,
            ),

            const SizedBox(height: 16),

            // ── Email ──
            const _FieldLabel('Email'),
            const SizedBox(height: 8),
            _InputField(
              controller: controller.emailController,
              hint: 'contoh@email.com',
              icon: Icons.alternate_email_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
            ),

            const SizedBox(height: 16),

            // ── No. HP ──
            const _FieldLabel('No. HP'),
            const SizedBox(height: 8),
            _InputField(
              controller: controller.phoneController,
              hint: '08xxxxxxxxxx',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: controller.validatePhone,
            ),

            const SizedBox(height: 16),

            // ── Kata Sandi ──
            const _FieldLabel('Kata Sandi'),
            const SizedBox(height: 8),
            Obx(() => _InputField(
                  controller: controller.passwordController,
                  hint: 'Minimal 6 karakter',
                  icon: Icons.lock_outline_rounded,
                  obscureText: !controller.isPasswordVisible.value,
                  validator: controller.validatePassword,
                  suffix: GestureDetector(
                    onTap: controller.togglePasswordVisibility,
                    child: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFFB5B0A8),
                      size: 20,
                    ),
                  ),
                )),

            const SizedBox(height: 16),

            // ── Konfirmasi Kata Sandi ──
            const _FieldLabel('Konfirmasi Kata Sandi'),
            const SizedBox(height: 8),
            Obx(() => _InputField(
                  controller: controller.confirmPasswordController,
                  hint: 'Ulangi kata sandi',
                  icon: Icons.lock_outline_rounded,
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  validator: controller.validateConfirmPassword,
                  suffix: GestureDetector(
                    onTap: controller.toggleConfirmPasswordVisibility,
                    child: Icon(
                      controller.isConfirmPasswordVisible.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFFB5B0A8),
                      size: 20,
                    ),
                  ),
                )),

            const SizedBox(height: 20),

            // ── Checkbox Syarat & Ketentuan ──
            Obx(() => GestureDetector(
                  onTap: controller.toggleAgreeToTerms,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: controller.isAgreeToTerms.value
                              ? _kOrange
                              : Colors.white,
                          border: Border.all(
                            color: controller.isAgreeToTerms.value
                                ? _kOrange
                                : const Color(0xFFCEC9C1),
                            width: 1.5,
                          ),
                        ),
                        child: controller.isAgreeToTerms.value
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 13)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: const Color(0xFF8A8278),
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(text: 'Saya menyetujui '),
                              TextSpan(
                                text: 'Syarat & Ketentuan',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: _kOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' serta '),
                              TextSpan(
                                text: 'Kebijakan Privasi',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: _kOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' Hajato.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 24),

            // ── Tombol Daftar ──
            Obx(() => _OrangeButton(
                  label: 'Daftar Sekarang',
                  isLoading: controller.isLoading.value,
                  onTap: controller.register,
                )),

            const SizedBox(height: 20),

            // ── Divider atau ──
            Row(
              children: [
                const Expanded(child: Divider(color: Color(0xFFEDE9E1))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'atau daftar dengan',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: const Color(0xFFB5B0A8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: Color(0xFFEDE9E1))),
              ],
            ),

            const SizedBox(height: 16),

            // ── Social Buttons ──
            Row(
              children: [
                Expanded(
                  child: _SocialButton(
                    label: 'Google',
                    color: const Color(0xFFFFF0F0),
                    initial: 'G',
                    initialColor: const Color(0xFFDB4437),
                    onTap: controller.registerWithGoogle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SocialButton(
                    label: 'Facebook',
                    color: const Color(0xFFE8F0FE),
                    initial: 'f',
                    initialColor: const Color(0xFF1877F2),
                    onTap: controller.registerWithFacebook,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Sudah punya akun ──
            Center(
              child: GestureDetector(
                onTap: controller.goToLogin,
                child: Text.rich(
                  TextSpan(
                    style: GoogleFonts.dmSans(fontSize: 13),
                    children: [
                      const TextSpan(
                        text: 'Sudah punya akun? ',
                        style: TextStyle(color: Color(0xFF8A8278)),
                      ),
                      TextSpan(
                        text: 'Masuk →',
                        style: GoogleFonts.dmSans(
                          color: _kOrange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── SSL Badge ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline_rounded,
                    size: 13, color: _kOrange.withOpacity(0.5)),
                const SizedBox(width: 5),
                Text(
                  'Terenkripsi & aman dengan SSL 256-bit',
                  style: GoogleFonts.dmSans(
                      fontSize: 11, color: const Color(0xFFB5B0A8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Widgets (sama persis dengan LoginView) ────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: const Color(0xFF8A8278),
        ),
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

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      style: GoogleFonts.dmSans(fontSize: 14, color: const Color(0xFF18130A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.dmSans(fontSize: 14, color: const Color(0xFFC0BBB5)),
        prefixIcon: Icon(icon, size: 18, color: _kOrange.withOpacity(0.6)),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFEDE9E1), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFEDE9E1), width: 1.5),
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
}

class _OrangeButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;
  const _OrangeButton(
      {required this.label, required this.isLoading, required this.onTap});

  @override
  State<_OrangeButton> createState() => _OrangeButtonState();
}

class _OrangeButtonState extends State<_OrangeButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!widget.isLoading) widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
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
                color: _kOrange.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    widget.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final String label;
  final Color color;
  final String initial;
  final Color initialColor;
  final VoidCallback onTap;
  const _SocialButton({
    required this.label,
    required this.color,
    required this.initial,
    required this.initialColor,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: const Border.fromBorderSide(
              BorderSide(color: Color(0xFFEDE9E1), width: 1.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: widget.color,
                ),
                child: Center(
                  child: Text(
                    widget.initial,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: widget.initialColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4A4440),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}