import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:online_image_classification/service/firebase_ml_service.dart';
import 'package:online_image_classification/service/camera_stream_isolate.dart';

class CameraProvider extends ChangeNotifier {
  bool isCameraInitialized = false;
  bool isDetecting = false;
  bool isModelReady = false;
  String? errorMessage;

  String predictedName = "";
  String confidenceString = "";
  String liveResult = "Mengarahkan kamera...";

  List<CameraDescription> cameras = [];
  CameraController? controller;

  final CameraStreamIsolate _cameraStreamIsolate = CameraStreamIsolate();

  final Map<int, String> _foodLabels = {
    1234: "Sushi",
    170: "Lasagna",
    319: "Nasi Lemak",
    263: "Satay",
    1225: "Beef Bourguignon",
  };

  bool isBackCameraSelected = true;

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  Future<void> initCamera() async {
    try {
      await _loadModel();

      if (cameras.isEmpty) {
        cameras = await availableCameras();
      }
      await onNewCameraSelected(cameras.first);
      errorMessage = null;
    } catch (_) {
      errorMessage =
          'Kamera gagal diinisialisasi. Cek izin kamera dan koneksi internet.';
      notifyListeners();
    }
  }

  Future<void> _loadModel() async {
    final modelFile = await FirebaseMlService().loadModel();
    await _cameraStreamIsolate.start(modelFile.path);
    isModelReady = true;
    notifyListeners();
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    final cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420
          : ImageFormatGroup.bgra8888,
    );

    await previousCameraController?.dispose();

    await cameraController.initialize();

    controller = cameraController;
    isCameraInitialized = controller!.value.isInitialized;

    notifyListeners();

    _startImageStream();
  }

  void _startImageStream() {
    controller?.startImageStream((image) async {
      if (!isModelReady || isDetecting) return;

      isDetecting = true;

      try {
        final result = await _cameraStreamIsolate.predict(
          width: image.width,
          height: image.height,
          isBgra8888: Platform.isIOS,
          planes: image.planes
              .map(
                (plane) => CameraPlaneData(
                  bytes: plane.bytes,
                  bytesPerRow: plane.bytesPerRow,
                  bytesPerPixel: plane.bytesPerPixel,
                ),
              )
              .toList(),
        );

        predictedName = _foodLabels[result.index] ?? "Makanan Tidak Dikenal";

        final confidencePercent = result.isUint8
            ? (result.confidence / 255 * 100).toStringAsFixed(2)
            : (result.confidence * 100).toStringAsFixed(2);

        confidenceString = "$confidencePercent%";
        liveResult = "$predictedName ($confidenceString)";
        errorMessage = null;
        notifyListeners();
      } catch (_) {
        errorMessage =
            'Deteksi real-time sedang bermasalah. Coba lagi sebentar.';
        notifyListeners();
      } finally {
        Future.delayed(const Duration(milliseconds: 500), () {
          isDetecting = false;
        });
      }
    });
  }

  void switchCamera() async {
    if (cameras.length == 1) return;

    try {
      isCameraInitialized = false;
      notifyListeners();

      await onNewCameraSelected(
        cameras[isBackCameraSelected ? 1 : 0],
      );

      isBackCameraSelected = !isBackCameraSelected;
      errorMessage = null;
      notifyListeners();
    } catch (_) {
      errorMessage = 'Gagal mengganti kamera. Coba lagi.';
      notifyListeners();
    }
  }

  Future<XFile?> takePicture() async {
    try {
      if (controller == null || !controller!.value.isInitialized) return null;
      if (controller!.value.isTakingPicture) return null;

      final wasStreaming = controller!.value.isStreamingImages;
      if (wasStreaming) {
        await controller!.stopImageStream();
      }

      final picture = await controller!.takePicture();

      if (wasStreaming) {
        _startImageStream();
      }

      return picture;
    } catch (_) {
      errorMessage = 'Gagal mengambil gambar. Coba lagi.';
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    controller?.stopImageStream();
    controller?.dispose();
    _cameraStreamIsolate.dispose();
    super.dispose();
  }
}
