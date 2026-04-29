import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/api/api_service.dart';
import '../data/preference/auth_preference.dart';
import '../data/model/story.dart';

enum ResultState { loading, noData, hasData, error }

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthPreferences authPreferences;

  int? _pageItems = 1;
  final int _sizeItems = 10;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  List<Story> _storiesList = [];
  List<Story> get storiesList => _storiesList;
  bool get hasMore => _hasMore;
  bool get isFetchingMore => _isFetchingMore;

  LatLng? _selectedLocation;
  LatLng? get selectedLocation => _selectedLocation;

  String? _address;
  String? get address => _address;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  StoryProvider({required this.apiService, required this.authPreferences});

  ResultState _state = ResultState.loading;
  String _message = '';

  ResultState get state => _state;
  String get message => _message;

  void clearLocation() {
    _selectedLocation = null;
    _address = null;
    notifyListeners();
  }

  // TAMBAHKAN PARAMETER TEKS TERJEMAHAN DI SINI
  Future<void> setLocation(LatLng loc, {String? loadingText, String? notFoundText}) async {
    _selectedLocation = loc;
    _address = loadingText ?? "Sedang mencari alamat...";
    notifyListeners();

    try {
      final placemarks = await placemarkFromCoordinates(loc.latitude, loc.longitude);
      if (placemarks.isNotEmpty) {
        _address = "${placemarks.first.street}, ${placemarks.first.locality}";
      } else {
        _address = notFoundText ?? "Alamat tidak ditemukan";
      }
    } catch (e) {
      _address = notFoundText ?? "Alamat tidak ditemukan";
    }
    notifyListeners();
  }

  Future<void> fetchAllStories({bool refresh = false}) async {
    if (refresh) {
      _pageItems = 1;
      _hasMore = true;
      _storiesList.clear();
      _state = ResultState.loading;
      notifyListeners();
    }
    if (!_hasMore) return;

    try {
      if (_pageItems == 1) {
        _state = ResultState.loading;
      } else {
        _isFetchingMore = true;
      }
      notifyListeners();

      final token = await authPreferences.getToken();

      if (token != null) {
        final storyData = await apiService.getStories(token, page: _pageItems!, size: _sizeItems);
        if (storyData.listStory.isEmpty) {
          _hasMore = false;
          if (_pageItems == 1) {
            _state = ResultState.noData;
            // Pesan ini tidak akan dipakai lagi oleh UI, karena UI akan menerjemahkan sendiri
            _message = 'Empty Data';
          }
        } else {
          _state = ResultState.hasData;
          _storiesList.addAll(storyData.listStory);
          if (storyData.listStory.length < _sizeItems) {
            _hasMore = false;
          } else {
            _pageItems = _pageItems! + 1;
          }
        }
      } else {
        _state = ResultState.error;
        _message = 'Session Expired';
      }
    } catch (e) {
      if (_pageItems == 1) {
        _state = ResultState.error;
        _message = 'Network Error';
      }
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<bool> uploadStory(String description, List<int> bytes, String fileName, {double? lat, double? lon}) async {
    try {
      _isUploading = true;
      notifyListeners();
      final token = await authPreferences.getToken();
      if (token == null) return false;

      await apiService.addStory(token, description, bytes, fileName, lat: lat, lon: lon);
      await fetchAllStories(refresh: true);
      _isUploading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isUploading = false;
      _message = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}