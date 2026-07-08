import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';

class FaceEnrollmentView extends StatefulWidget {
  const FaceEnrollmentView({super.key});

  @override
  State<FaceEnrollmentView> createState() => _FaceEnrollmentViewState();
}

class _FaceEnrollmentViewState extends State<FaceEnrollmentView>
    with WidgetsBindingObserver {
  CameraController? _cameraController;

  bool _isCameraReady = false;
  bool _isCapturing = false;
  String? _errorMessage;

  final List<File> _images = [];

  final List<Map<String, String>> _steps = [
    {
      'title': 'Foto 1 dari 3',
      'message': 'Hadapkan wajah lurus ke kamera',
    },
    {
      'title': 'Foto 2 dari 3',
      'message': 'Tersenyum ke kamera',
    },
    {
      'title': 'Foto 3 dari 3',
      'message': 'Miringkan wajah sedikit ke kanan atau kiri',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      controller.dispose();
      _cameraController = null;
      _isCameraReady = false;
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'Kamera tidak ditemukan';
          _isCameraReady = false;
        });
        return;
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();

      if (!mounted) return;

      setState(() {
        _cameraController = controller;
        _isCameraReady = true;
        _errorMessage = null;
      });
    } catch (e) {
      debugPrint('INIT CAMERA ERROR: $e');

      if (!mounted) return;

      setState(() {
        _errorMessage = 'Kamera tidak dapat dibuka';
        _isCameraReady = false;
      });
    }
  }

  Future<void> _captureImage() async {
    final controller = _cameraController;

    if (controller == null ||
        !controller.value.isInitialized ||
        _isCapturing ||
        _images.length >= 3) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
      });

      final XFile xFile = await controller.takePicture();

      if (!mounted) return;

      setState(() {
        _images.add(File(xFile.path));
      });
    } catch (e) {
      debugPrint('CAPTURE IMAGE ERROR: $e');

      Get.snackbar(
        'Gagal',
        'Gagal mengambil foto wajah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEDED),
        colorText: const Color(0xFF991F1F),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _resetImages() {
    setState(() {
      _images.clear();
    });
  }

  void _finishEnrollment() {
    if (_images.length < 3) {
      Get.snackbar(
        'Belum Lengkap',
        'Ambil 3 foto wajah terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.back(result: List<File>.from(_images));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    if (!_isCameraReady || _cameraController == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: _buildCameraPreview(),
        ),

        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.12),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              const Spacer(),
              _buildBottomPanel(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCameraPreview() {
    final controller = _cameraController!;
    final previewSize = controller.value.previewSize;

    if (previewSize == null) {
      return CameraPreview(controller);
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: previewSize.height,
        height: previewSize.width,
        child: CameraPreview(controller),
      ),
    );
  }

  Widget _buildTopBar() {
    final isComplete = _images.length >= 3;
    final stepIndex = isComplete ? 2 : _images.length;
    final step = _steps[stepIndex];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isComplete ? 'Preview Foto Wajah' : step['title']!,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isComplete
                        ? 'Cek 3 foto wajah sebelum digunakan'
                        : step['message']!,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.82),
                      fontSize: 11,
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

  Widget _buildBottomPanel() {
    final isComplete = _images.length >= 3;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPreviewRow(),
          const SizedBox(height: 16),

          if (!isComplete)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isCapturing ? null : _captureImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: _isCapturing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.camera_alt_rounded),
                label: Text(
                  _isCapturing
                      ? 'Mengambil Foto...'
                      : 'Ambil Foto ${_images.length + 1}/3',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetImages,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size.fromHeight(52),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      'Ulangi',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _finishEnrollment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size.fromHeight(52),
                    ),
                    icon: const Icon(Icons.check_circle_rounded),
                    label: Text(
                      'Gunakan Foto',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPreviewRow() {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == 2 ? 0 : 10,
            ),
            child: _buildPreviewItem(index),
          ),
        );
      }),
    );
  }

  Widget _buildPreviewItem(int index) {
    final hasImage = index < _images.length;

    return AspectRatio(
      aspectRatio: 0.82,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasImage ? AppColors.primary : const Color(0xFFB2DFDB),
                width: 1.5,
              ),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      _images[index],
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                  ),
          ),

          if (hasImage)
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}