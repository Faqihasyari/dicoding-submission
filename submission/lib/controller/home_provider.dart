import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_image_classification/ui/camera_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../service/firebase_ml_service.dart';
import '../service/inference_isolate.dart';

class HomeProvider extends ChangeNotifier {
  String? imagePath;
  String result = "";

  String predictedName = "";
  String confidenceString = "";

// Ganti variabel Map sebelumnya dengan List ini
  Map<int, String> foodLabels = {
    1234: "Sushi",
    170: "Lasagna",
    319: "Nasi Lemak",
    263: "Satay",
    1225: "Beef Bourguignon",
  };


  XFile? imageFile;

  void _setImage(XFile? value) {
    imageFile = value;
    imagePath = value?.path;
    notifyListeners();
  }

  void openCamera() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      _setImage(pickedFile);
    }
  }

  Future<void> cropImage() async {
    if (imagePath == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath!,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false
        ),
      ],
    );

    if (croppedFile != null) {
      _setImage(XFile(croppedFile.path));
    }
  }

  Future<void> analyzeImage() async {
    if (imagePath == null) return;

    final modelFile = await FirebaseMlService().loadModel();

    final resultData = await compute(
      runInferenceIsolate,
      {
        "modelPath": modelFile.path,
        "imagePath": imagePath!,
      },
    );

    final index = resultData['index'];
    final confidence = resultData['confidence'];

    // 🔥 PERBAIKAN: Cara memanggil Map yang benar
    // Cek apakah angka dari ML ada di dalam Map kita
    if (foodLabels.containsKey(index)) {
      predictedName = foodLabels[index]!;
    } else {
      // Jika angka yang keluar tidak ada di Map, kita print ke console untuk mencari tahu angka aslinya
      print("⚠️ PERHATIAN: ML mengeluarkan index yang tidak dikenal: $index");
      predictedName = "Makanan Tidak Dikenal";
    }

    final confidencePercent = (confidence / 255 * 100).toStringAsFixed(2);
    confidenceString = "$confidencePercent%";

    result = "$predictedName ($confidenceString)";

    notifyListeners();
  }

  void openGallery() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      _setImage(pickedFile);
    }
  }

  void openCustomCamera(BuildContext context) async {
    final XFile? resultImageFile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(),
      ),
    );

    if (resultImageFile != null) {
      _setImage(resultImageFile);
    }
  }
}
