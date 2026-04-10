import 'dart:convert';

MealResponse mealResponseFromJson(String str) =>
    MealResponse.fromJson(json.decode(str));

String mealResponseToJson(MealResponse data) => json.encode(data.toJson());

class MealResponse {
  List<Map<String, String?>>? meals;

  MealResponse({
    this.meals,
  });

  factory MealResponse.fromJson(Map<String, dynamic> json) => MealResponse(
        meals: json["meals"] == null
            ? null
            : List<Map<String, String?>>.from(json["meals"].map((x) =>
                Map.from(x).map((k, v) => MapEntry<String, String?>(k, v)))),
      );

  Map<String, dynamic> toJson() => {
        "meals": meals == null
            ? null
            : List<dynamic>.from(meals!.map((x) =>
                Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
      };
}
