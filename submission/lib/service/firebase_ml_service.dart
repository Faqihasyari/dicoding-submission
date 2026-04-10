import 'dart:io';
import 'dart:async';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class FirebaseMlService {
  Future<File> loadModel() async {
    try {
      final model = await FirebaseModelDownloader.instance
          .getModel(
            "food-classifier",
            FirebaseModelDownloadType.localModelUpdateInBackground,
            FirebaseModelDownloadConditions(
              androidWifiRequired: false,
            ),
          )
          .timeout(const Duration(seconds: 20));

      return model.file;
    } on SocketException {
      throw Exception('Tidak ada koneksi internet untuk mengunduh model.');
    } on TimeoutException {
      throw Exception('Unduhan model terlalu lama. Coba lagi.');
    } catch (_) {
      throw Exception('Gagal memuat model machine learning.');
    }
  }
}
