import 'package:flutter/material.dart';
import '../service/gemini_service.dart';
import '../service/meal_service.dart';

class DetailProvider extends ChangeNotifier {
  Map<String, String?>? mealData;
  Map<String, dynamic>? nutritionData;
  String? mealErrorMessage;
  String? nutritionErrorMessage;

  bool isLoading = true;
  bool _isDisposed = false;

  static final Map<String, Map<String, String?>?> _mealCache = {};
  static final Map<String, Map<String, dynamic>?> _nutritionCache = {};

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> loadData(String foodName) async {
    isLoading = true;
    mealErrorMessage = null;
    nutritionErrorMessage = null;
    if (!_isDisposed) notifyListeners();

    if (_mealCache.containsKey(foodName) &&
        _nutritionCache.containsKey(foodName)) {
      mealData = _mealCache[foodName];
      nutritionData = _nutritionCache[foodName];

      if (!_isDisposed) {
        isLoading = false;
        notifyListeners();
      }
      return;
    }

    try {
      final result = await MealService().searchMeal(foodName);
      if (result != null && result.meals != null && result.meals!.isNotEmpty) {
        mealData = result.meals![0];
      } else {
        mealData = null;
      }
    } catch (e) {
      mealData = null;
      mealErrorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    try {
      final nutritionResult = await GeminiService().getNutrition(foodName);
      nutritionData = nutritionResult;
    } catch (e) {
      nutritionErrorMessage = e.toString().replaceFirst('Exception: ', '');
      nutritionData = {
        "calories": 0,
        "carbs": 0,
        "protein": 0,
        "fat": 0,
        "fiber": 0,
      };
    }

    _mealCache[foodName] = mealData;
    _nutritionCache[foodName] = nutritionData;

    if (!_isDisposed) {
      isLoading = false;
      notifyListeners();
    }
  }
}
