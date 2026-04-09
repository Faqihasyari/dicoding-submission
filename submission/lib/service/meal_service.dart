import 'package:http/http.dart' as http;
import '../model/meal_model.dart'; // Sesuaikan lokasi import

class MealService {
  Future<MealResponse?> searchMeal(String foodName) async {
    try {
      final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$foodName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Mengonversi JSON string dari internet menjadi object MealResponse
        return mealResponseFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching meal: $e");
      return null;
    }
  }
}