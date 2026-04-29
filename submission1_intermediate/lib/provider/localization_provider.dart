import 'package:flutter/material.dart';

class LocalizationProvider extends ChangeNotifier {
  // Default aplikasi kita adalah Bahasa Indonesia ('id')
  Locale _locale = const Locale('id');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners(); // Beri tahu seluruh aplikasi untuk ganti bahasa!
  }
}