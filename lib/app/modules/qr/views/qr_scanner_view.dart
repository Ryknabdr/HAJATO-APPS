import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/qr_controller.dart';
import '../../../modules/guest/controllers/guest_controller.dart';
import '../../../core/theme/app_theme.dart';

class QrScannerView extends GetView<QrController> {
  const QrScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final scannerController = MobileScannerController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          // Camera preview
          MobileScanner(
            controller: scannerController,
            onDetect: (capture) async {
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                final code = barcodes.first.rawValue!;
                
                try {
                  // 🟢 FIX UTAMA: Cek apakah GuestController sudah terdaftar di memori, jika belum langsung di-put
                  late GuestController guestCtrl;
                  if (Get.isRegistered<GuestController>()) {
                    guestCtrl = Get.find<GuestController>();
                  } else {
                    guestCtrl = Get.put(GuestController());
                  }
                  
                  // Kunci: Jika tidak sedang memproses, langsung amankan alur scan
                  if (!guestCtrl.isProcessingScan.value) {
                    guestCtrl.isProcessingScan.value = true; // Kunci menyala!
                    
                    controller.onScanDetect(code); // Trigger status UI bawah
                    
                    // Tembak API ke Flask dan tunggu sampai delay selesai (await)
                    await guestCtrl.checkIn(code);       
                    
                  } else {
                    print("[DEBUG HAJATO] SCANNER DIABAIKAN KARENA SEDANG PROSES.");
                  }
                } catch (e) {
                  controller.onScanDetect(code);
                  print("[DEBUG HAJATO] ERROR ON_DETECT: $e");
                }
              }
            },
          ),

          // Overlay
          _buildOverlay(),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Scan QR Tamu',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  IconButton(
                    onPressed: () => scannerController.toggleTorch(),
                    icon: const Icon(Icons.flashlight_on_rounded, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () => scannerController.switchCamera(),
                    icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Bottom status bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Stack(
      children: [
        // Dark overlay
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOut),
          child: Stack(
            children: [
              Container(decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut)),
              Center(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
        // Scanner frame corners
        Center(
          child: SizedBox(
            width: 240,
            height: 240,
            child: Stack(
              children: [
                // Top-left
                Positioned(top: 0, left: 0, child: _Corner()),
                Positioned(top: 0, right: 0, child: _Corner(flipX: true)),
                Positioned(bottom: 0, left: 0, child: _Corner(flipY: true)),
                Positioned(bottom: 0, right: 0, child: _Corner(flipX: true, flipY: true)),
                // Scanning line animation
                _ScanLine(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final status = controller.scanStatus.value;
            if (status == 'idle' || status.isEmpty) {
              return Column(children: [
                const Icon(Icons.qr_code_scanner_rounded, color: Colors.white54, size: 36),
                const SizedBox(height: 8),
                Text('Arahkan kamera ke QR Code tamu',
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
              ]);
            } else if (status == 'success') {
              return _StatusResult(
                icon: Icons.check_circle_rounded,
                message: '✅ Check-in Berhasil!',
                subMessage: controller.scanResult.value,
                color: AppColors.success,
              );
            } else {
              return _StatusResult(
                icon: Icons.error_rounded,
                message: '❌ QR Tidak Valid',
                subMessage: 'Tamu tidak ditemukan dalam daftar',
                color: AppColors.error,
              );
            }
          }),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final bool flipX;
  final bool flipY;
  const _Corner({this.flipX = false, this.flipY = false});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: flipX ? -1 : 1,
      scaleY: flipY ? -1 : 1,
      child: SizedBox(
        width: 36,
        height: 36,
        child: CustomPaint(painter: _CornerPainter()),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);
    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ScanLine extends StatefulWidget {
  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: 1).animate(_ctrl);
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
      builder: (_, __) => Positioned(
        top: _anim.value * 200,
        left: 0,
        right: 0,
        child: Container(height: 2, decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.transparent, AppColors.primary, Colors.transparent]),
        )),
      ),
    );
  }
}

class _StatusResult extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subMessage;
  final Color color;
  const _StatusResult({required this.icon, required this.message, required this.subMessage, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.5))),
        child: Row(
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(message, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                Text(subMessage, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
          ],
        ),
      );
}