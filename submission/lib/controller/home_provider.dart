import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show rootBundle; // 🔥 1. IMPORT BARU UNTUK BACA ASSETS
import 'package:online_image_classification/ui/camera_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../service/firebase_ml_service.dart';
import '../service/inference_isolate.dart';

class HomeProvider extends ChangeNotifier {
  String? imagePath;
  String result = "";
  String? errorMessage;
  bool isAnalyzing = false;

  String predictedName = "";
  String confidenceString = "";

  XFile? imageFile;

  void _setError(String message) {
    errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  void _setImage(XFile? value) {
    imageFile = value;
    imagePath = value?.path;
    errorMessage = null;
    notifyListeners();
  }

  void openCamera() async {
    try {
      final picker = ImagePicker();

      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        _setImage(pickedFile);
      }
    } catch (_) {
      _setError('Gagal membuka kamera. Cek izin kamera dan coba lagi.');
    }
  }

  Future<void> cropImage() async {
    if (imagePath == null) {
      _setError('Pilih gambar dulu sebelum melakukan crop.');
      return;
    }

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath!,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
        ],
      );

      if (croppedFile != null) {
        _setImage(XFile(croppedFile.path));
      }
    } catch (_) {
      _setError('Gagal melakukan crop gambar. Coba lagi.');
    }
  }

  Future<bool> analyzeImage() async {
    if (imagePath == null) {
      _setError('Pilih atau ambil gambar terlebih dahulu.');
      return false;
    }

    try {
      isAnalyzing = true;
      errorMessage = null;
      notifyListeners();

      final modelFile = await FirebaseMlService().loadModel();

      final labelString = await rootBundle.loadString('assets/labels.txt');

      final List<String> foodLabels = labelString
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final resultData = await compute(
        runInferenceIsolate,
        {
          "modelPath": modelFile.path,
          "imagePath": imagePath!,
        },
      );

      final index = resultData['index'];
      final confidence = resultData['confidence'];

      if (index >= 0 && index < foodLabels.length) {
        predictedName = foodLabels[index];
      } else {
        predictedName = "Makanan Tidak Dikenal";
      }

      final confidencePercent = (confidence / 255 * 100).toStringAsFixed(2);
      confidenceString = "$confidencePercent%";

      result = "$predictedName ($confidenceString)";

      notifyListeners();
      return true;
    } catch (_) {
      _setError(
        'Analisis gagal. Pastikan internet aktif untuk download model dan coba lagi.',
      );
      return false;
    } finally {
      isAnalyzing = false;
      notifyListeners();
    }
  }

  void openGallery() async {
    try {
      final picker = ImagePicker();

      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        _setImage(pickedFile);
      }
    } catch (_) {
      _setError('Gagal membuka galeri. Cek izin media dan coba lagi.');
    }
  }

  void openCustomCamera(BuildContext context) async {
    try {
      final XFile? resultImageFile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraPage(),
        ),
      );

      if (resultImageFile != null) {
        _setImage(resultImageFile);
      }
    } catch (_) {
      _setError('Kamera kustom gagal dibuka. Coba lagi.');
    }
  }
}
