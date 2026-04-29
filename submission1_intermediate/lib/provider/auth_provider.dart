import 'dart:io';

import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../data/preference/auth_preference.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthPreferences authPreferences;

  VoidCallback? onAuthSuccess;

  AuthProvider({required this.apiService, required this.authPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> checkLoginStatus() async {
    final token = await authPreferences.getToken();
    _isLoggedIn = token != null;

    _isInitialized = true;
    notifyListeners();

    if (_isLoggedIn) {
      onAuthSuccess?.call();
    }
  }

  Future<bool> login(String email, String password, {String? noInternetMessage}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await apiService.login(email, password);
      await authPreferences.saveToken(token);
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();

      onAuthSuccess?.call();

      return true;
    } catch (e) {
      _isLoading = false;

      if (e is SocketException || e.toString().contains('SocketFailed') || e.toString().contains('ClientException')) {
        // GUNAKAN PESAN DARI UI
        _errorMessage = noInternetMessage ?? 'Tidak ada koneksi internet.';
      } else {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }

      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, {String? noInternetMessage}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await apiService.register(name, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      if (e is SocketException || e.toString().contains('SocketFailed') || e.toString().contains('ClientException')) {
        // GUNAKAN PESAN DARI UI
        _errorMessage = noInternetMessage ?? 'Tidak ada koneksi internet.';
      } else {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await authPreferences.removeToken();
    _isLoggedIn = false;

    _isLoading = false;
    notifyListeners();
  }
}
