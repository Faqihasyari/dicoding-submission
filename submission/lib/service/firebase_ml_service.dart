import 'dart:io';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class FirebaseMlService {
  Future<File> loadModel() async {
    final model = await FirebaseModelDownloader.instance.getModel(
      "food-classifier",
      FirebaseModelDownloadType.localModelUpdateInBackground,
      FirebaseModelDownloadConditions(
        androidWifiRequired: false,
      ),
    );

    return model.file;
  }
}