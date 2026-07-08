import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../core/theme/app_theme.dart';

class FaceLoginView extends StatefulWidget {
  const FaceLoginView({super.key});

  @override
  State<FaceLoginView> createState() => _FaceLoginViewState();
}

class _FaceLoginViewState extends State<FaceLoginView>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  CameraDescription? _cameraDescription;
  FaceDetector? _faceDetector;

  bool _isCameraReady = false;
  bool _isProcessingFrame = false;
  bool _isCapturing = false;
  bool _faceDetected = false;

  DateTime? _faceDetectedAt;
  String _statusText = 'Arahkan wajah ke dalam lingkaran';

  final Map<DeviceOrientation, int> _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initFaceDetector();
    _initCamera();
  }

  void _initFaceDetector() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableContours: false,
        enableLandmarks: false,
        enableClassification: false,
        enableTracking: false,
        minFaceSize: 0.18,
      ),
    );
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          _statusText = 'Kamera tidak ditemukan';
        });
        return;
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraDescription = frontCamera;

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await controller.initialize();

      if (!mounted) return;

      setState(() {
        _cameraController = controller;
        _isCameraReady = true;
      });

      await controller.startImageStream(_processCameraImage);
    } catch (e) {
      debugPrint('FACE LOGIN INIT CAMERA ERROR: $e');

      if (!mounted) return;

      setState(() {
        _statusText = 'Kamera tidak dapat dibuka';
      });
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessingFrame || _isCapturing) return;

    final detector = _faceDetector;
    if (detector == null) return;

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;

    _isProcessingFrame = true;

    try {
      final faces = await detector.processImage(inputImage);

      if (!mounted || _isCapturing) return;

      if (faces.isNotEmpty) {
        _faceDetectedAt ??= DateTime.now();

        setState(() {
          _faceDetected = true;
          _statusText = 'Wajah terdeteksi, tahan sebentar...';
        });

        final detectedDuration = DateTime.now().difference(_faceDetectedAt!);

        if (detectedDuration.inMilliseconds >= 900) {
          await _captureAndReturn();
        }
      } else {
        _faceDetectedAt = null;

        setState(() {
          _faceDetected = false;
          _statusText = 'Arahkan wajah ke dalam lingkaran';
        });
      }
    } catch (e) {
      debugPrint('FACE DETECTION ERROR: $e');
    } finally {
      _isProcessingFrame = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameraDescription;
    final controller = _cameraController;

    if (camera == null || controller == null) return null;

    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[controller.value.deviceOrientation];

      if (rotationCompensation == null) return null;

      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation =
            (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }

      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null) return null;

    final bytes = _concatenatePlanes(image.planes);

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final allBytes = WriteBuffer();

    for (final plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }

    return allBytes.done().buffer.asUint8List();
  }

  Future<void> _captureAndReturn() async {
    if (_isCapturing) return;

    final controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) return;

    try {
      setState(() {
        _isCapturing = true;
        _statusText = 'Memverifikasi wajah...';
      });

      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }

      await Future.delayed(const Duration(milliseconds: 250));

      final XFile file = await controller.takePicture();

      if (!mounted) return;

      Get.back(result: File(file.path));
    } catch (e) {
      debugPrint('FACE LOGIN CAPTURE ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isCapturing = false;
        _faceDetected = false;
        _faceDetectedAt = null;
        _statusText = 'Gagal mengambil wajah, coba lagi';
      });

      try {
        await controller.startImageStream(_processCameraImage);
      } catch (_) {}
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _faceDetector?.close();

    final controller = _cameraController;

    if (controller != null) {
      if (controller.value.isStreamingImages) {
        controller.stopImageStream().catchError((_) {});
      }
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _cameraController;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isCameraReady && controller != null)
            Positioned.fill(
              child: _buildCameraPreview(controller),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.18),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                _buildScannerCircle(),
                const Spacer(),
                _buildBottomInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview(CameraController controller) {
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
              child: Text(
                'Login dengan Face ID',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerCircle() {
    return SizedBox(
      width: 270,
      height: 270,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 245,
            height: 245,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _faceDetected
                    ? AppColors.primary
                    : Colors.white.withOpacity(0.85),
                width: 3,
              ),
            ),
          ),

          if (_faceDetected || _isCapturing)
            SizedBox(
              width: 270,
              height: 270,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: AppColors.primary,
              ),
            ),

          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.42),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isCapturing
                  ? Icons.verified_user_rounded
                  : Icons.face_retouching_natural_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.48),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        _statusText,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}