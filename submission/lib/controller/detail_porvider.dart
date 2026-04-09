import 'package:flutter/material.dart';
import '../service/gemini_service.dart';
import '../service/meal_service.dart';

class DetailProvider extends ChangeNotifier {
  Map<String, String?>? mealData;
  Map<String, dynamic>? nutritionData;

  bool isLoading = true;
  bool _isDisposed = false;

  // 🔥 1. BUAT CACHE (Memori Ingatan)
  // Variabel static ini tidak akan hilang saat halaman ditutup
  static final Map<String, Map<String, String?>?> _mealCache = {};
  static final Map<String, Map<String, dynamic>?> _nutritionCache = {};

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> loadData(String foodName) async {
    isLoading = true;
    if (!_isDisposed) notifyListeners();

    // 🔥 2. CEK CACHE SEBELUM MEMANGGIL API
    // Jika data makanan ini sudah ada di dalam ingatan, pakai yang ada saja!
    if (_mealCache.containsKey(foodName) && _nutritionCache.containsKey(foodName)) {
      print("⚡ Mengambil data '$foodName' dari Cache (Sangat Cepat & Tanpa Internet!)");
      mealData = _mealCache[foodName];
      nutritionData = _nutritionCache[foodName];

      if (!_isDisposed) {
        isLoading = false;
        notifyListeners();
      }
      return; // Berhenti di sini, JANGAN lanjut panggil API TheMealDB & Gemini
    }

    print("🌐 Belum ada di Cache. Mengunduh data '$foodName' dari Internet...");

    // --- MULAI PROSES PEMANGGILAN API (Hanya jalan jika belum pernah dicari) ---

    // 1. Ambil data dari MealDB
    final result = await MealService().searchMeal(foodName);
    if (result != null && result.meals != null && result.meals!.isNotEmpty) {
      mealData = result.meals![0];
    } else {
      mealData = null;
    }

    // 2. Ambil data dari Gemini API
    try {
      final nutritionResult = await GeminiService().getNutrition(foodName);
      nutritionData = nutritionResult;
    } catch (e) {
      print("Gemini Error / Limit: $e");
      nutritionData = {
        "calories": 0, "carbs": 0, "protein": 0, "fat": 0, "fiber": 0,
      };
    }

    // 🔥 3. SIMPAN HASIL KE DALAM CACHE
    // Agar jika user menekan "Back" dan masuk lagi, datanya sudah tersimpan
    _mealCache[foodName] = mealData;
    _nutritionCache[foodName] = nutritionData;

    if (!_isDisposed) {
      isLoading = false;
      notifyListeners();
    }
  }
}