import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/onboarding_controller.dart';

const _kTeal = Color(0xFF0D9488);
const _kTealDark = Color(0xFF0F766E);
const _kTealLight = Color(0xFF14B8A6);
const _kTealBg = Color(0xFF0D9488);
const _kGold = Color(0xFFD97706);
const _kGoldLight = Color(0xFFFBBF24);

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kTeal,
      body: Stack(
        children: [
          const _BackgroundArt(),
          SafeArea(
            child: Column(
              children: [
                Expanded(flex: 5, child: _TopSection()),
                const _BottomPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundArt extends StatefulWidget {
  const _BackgroundArt();

  @override
  State<_BackgroundArt> createState() => _BackgroundArtState();
}

class _BackgroundArtState extends State<_BackgroundArt>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) =>
          CustomPaint(size: Size.infinite, painter: _BgPainter(_anim.value)),
    );
  }
}

class _BgPainter extends CustomPainter {
  final double t;
  _BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF14B8A6), // teal-500
          Color(0xFF0D9488), // teal-600
          Color(0xFF0F766E), // teal-700
        ],
        stops: [0, 0.5, 1],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Orb gold accent — subtle shimmer
    final scale1 = 1.0 + 0.15 * t;
    _drawOrb(
      canvas,
      center: const Offset(-60, -80),
      radius: 280 * scale1,
      color: Colors.white.withOpacity(0.12),
    );

    // Gold orb top-right
    final scale2 = 1.0 - 0.12 * t;
    _drawOrb(
      canvas,
      center: Offset(size.width + 40, 80),
      radius: 200 * scale2,
      color: const Color(0xFFFBBF24).withOpacity(0.08),
    );

    final scale3 = 1.0 + 0.1 * (1 - t);
    _drawOrb(
      canvas,
      center: Offset(20, size.height * 0.35),
      radius: 160 * scale3,
      color: Colors.white.withOpacity(0.06),
    );

    _drawGrid(canvas, size);
  }

  void _drawOrb(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
  }) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 0.5;
    const step = 40.0;
    final maxY = size.height * 0.55;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, maxY), paint);
    }
    for (double y = 0; y < maxY; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_BgPainter old) => old.t != t;
}

class _TopSection extends StatefulWidget {
  @override
  State<_TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<_TopSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _float = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _float,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, -8 * _float.value),
        child: child,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _IconFrame(),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Color(0xFFCCFBF1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'HAJATO',
              style: GoogleFonts.playfairDisplay(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'H A J A T A N  O R G A N I Z E R',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              letterSpacing: 4,
              color: Colors.black.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 28),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FeatureBadge(icon: '🏪', label: 'Vendor'),
              SizedBox(width: 10),
              _FeatureBadge(icon: '📲', label: 'QR Tamu'),
              SizedBox(width: 10),
              _FeatureBadge(icon: '✨', label: 'AI Chat'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Semua kebutuhan hajatan Anda,\ndalam satu genggaman',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: Colors.black.withOpacity(0.45),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconFrame extends StatefulWidget {
  const _IconFrame();

  @override
  State<_IconFrame> createState() => _IconFrameState();
}

class _IconFrameState extends State<_IconFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _blink;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _blink = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _kTealDark.withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/hajato.png',
                fit: BoxFit.cover,
                width: 96,
                height: 96,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _blink,
            builder: (_, __) => Stack(
              children: [
                // Gold accent dots
                Positioned(
                  top: 2,
                  left: 2,
                  child: _Dot(opacity: _blink.value, gold: true),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: _Dot(opacity: 1 - _blink.value, gold: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double opacity;
  final bool gold;
  const _Dot({required this.opacity, required this.gold});

  @override
  Widget build(BuildContext context) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: gold
              ? Color.lerp(
                  _kGoldLight.withOpacity(0.4), _kGoldLight, opacity)
              : Color.lerp(
                  Colors.white.withOpacity(0.3), Colors.white, opacity),
        ),
      );
}

class _FeatureBadge extends StatelessWidget {
  final String icon;
  final String label;
  const _FeatureBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(100),
          border:
              Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
}

class _BottomPanel extends GetView<OnboardingController> {
  const _BottomPanel();

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
            blurRadius: 60,
            offset: Offset(0, -20),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 3,
              margin: const EdgeInsets.only(bottom: 28),
              decoration: BoxDecoration(
                color: _kTeal.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F2724),
                height: 1.25,
                letterSpacing: -0.5,
              ),
              children: const [
                TextSpan(text: 'Selamat Datang di\n'),
                TextSpan(
                  text: 'Hajato',
                  style: TextStyle(color: _kTeal),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Platform terlengkap untuk merencanakan acara Anda. Cari vendor, kelola tamu, dan buat undangan digital.',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: const Color(0xFF4B7A76),
              height: 1.65,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _TealButton(
                  label: 'Masuk',
                  onTap: controller.goToLogin,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OutlineButton(
                  label: 'Daftar',
                  onTap: controller.goToRegister,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0xFFB2DFDB))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'atau',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFFA8C5C2),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: Color(0xFFB2DFDB))),
            ],
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: controller.goToVendorLogin,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _kGold.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: _kGold.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      gradient: const LinearGradient(
                        colors: [_kGoldLight, _kGold],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child:
                          Text('🏪', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Bergabung sebagai ',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: const Color(0xFF4B5563),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Vendor →',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: _kGold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TealButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _TealButton({required this.label, required this.onTap});

  @override
  State<_TealButton> createState() => _TealButtonState();
}

class _TealButtonState extends State<_TealButton> {
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
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [_kTealLight, _kTealDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _kTeal.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
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
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.transparent,
            border:
                Border.all(color: _kTeal.withOpacity(0.4), width: 1.5),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _kTeal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}