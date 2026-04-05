import 'package:google_ml_kit/google_ml_kit.dart';

class TextRecognitionService {
  Future<String> runRecognizedText(String path) async {
    final InputImage ip = InputImage.fromFilePath(path);

    final tr = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    final RecognizedText rt = await tr.processImage(ip);

    tr.close();

    return rt.text;
  }
}