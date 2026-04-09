import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider extends ChangeNotifier {
  bool isCameraInitialized = false;
  bool isDetecting = false;


  List<CameraDescription> cameras = [];
  CameraController? controller;

  bool isBackCameraSelected = true;

  Future<void> initCamera() async {
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }
    await onNewCameraSelected(cameras.first);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    final cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await previousCameraController?.dispose();

    await cameraController.initialize();

    controller = cameraController;
    isCameraInitialized = controller!.value.isInitialized;

    notifyListeners();

    controller!.startImageStream((image) {
      if (isDetecting) return;

      isDetecting = true;

      Future.delayed(const Duration(milliseconds: 500), () {
        isDetecting = false;
      });
    });
  }

  void switchCamera() async {
    if (cameras.length == 1) return;

    isCameraInitialized = false;
    notifyListeners();

    await onNewCameraSelected(
      cameras[isBackCameraSelected ? 1 : 0],
    );

    isBackCameraSelected = !isBackCameraSelected;
    notifyListeners();
  }

  Future<XFile?> takePicture() async {
    return await controller?.takePicture();
  }

  @override
  void dispose() {
    controller?.stopImageStream();
    controller?.dispose();
    super.dispose();
  }
}