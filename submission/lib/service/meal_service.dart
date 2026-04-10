import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../model/meal_model.dart';

class MealService {
  Future<MealResponse?> searchMeal(String foodName) async {
    try {
      final url = Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/search.php?s=$foodName');
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return mealResponseFromJson(response.body);
      } else {
        throw Exception('Server resep sedang bermasalah. Coba lagi nanti.');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet untuk memuat data resep.');
    } on TimeoutException {
      throw Exception('Permintaan data resep terlalu lama. Coba lagi.');
    } catch (_) {
      throw Exception('Gagal memuat data resep.');
    }
  }
}
