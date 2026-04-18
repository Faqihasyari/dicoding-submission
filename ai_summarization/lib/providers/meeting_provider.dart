import 'package:flutter/material.dart';

class MeetingProvider extends ChangeNotifier {
  bool _isRecording = false;
  bool _isLoading = false;
  String _currentSummary = '';

  bool get isRecording => _isLoading;
  bool get isLoading => _isLoading;
  String get currentSummary => _currentSummary;

  void toggleRecording() {
    _isRecording = !_isRecording;
    notifyListeners();
  }

  Future<void> processAudioToSummary() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    _currentSummary = "Ini adalah contoh hasil tangkapan rapat dari Gemini AI";

    _isLoading = false;
    notifyListeners();
  }
}