import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../service/text_recognition_service.dart';

class ResultProvider extends ChangeNotifier{
  final TextRecognitionService _service;
  String? detectedText;
  bool isProcessing = false;


  ResultProvider([
    TextRecognitionService? service,
  ]) : _service = service ?? TextRecognitionService();

  void runTextRecognition(String path) async {
    detectedText = null;
    isProcessing = true;
    notifyListeners();

    detectedText = await _service.runRecognizedText(path);
    isProcessing = false;
    notifyListeners();
  }

  void copyText(BuildContext context) async {
    if (detectedText == null) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final clipboardData = ClipboardData(text: detectedText!);
    await Clipboard.setData(clipboardData);

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('Copied to Clipboard!')),
    );
  }
}