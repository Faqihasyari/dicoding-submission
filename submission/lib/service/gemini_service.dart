import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../env/env.dart';

class GeminiService {
  // 🔥 PASTIKAN API KEY KAMU SUDAH BENAR DI SINI
  final String apiKey = Env.apiKey;

  Future<Map<String, dynamic>?> getNutrition(String foodName) async {
    final model = GenerativeModel(
      model: 'gemini-flash-lite-latest',
      apiKey: apiKey,
      systemInstruction: Content.system(
          'Saya adalah suatu mesin yang mampu mengidentifikasi nutrisi atau kandungan gizi pada makanan layaknya uji laboratorium makanan. Hal yang bisa diidentifikasi adalah kalori, karbohidrat, lemak, serat, dan protein pada makanan. Satuan dari indikator tersebut berupa gram.'),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: Schema.object(properties: {
          'nutrition': Schema.object(properties: {
            'calories': Schema.integer(),
            'carbs': Schema.integer(),
            'protein': Schema.integer(),
            'fat': Schema.integer(),
            'fiber': Schema.integer(),
          })
        }),
      ),
    );

    final prompt = 'Nama makanannya adalah $foodName.';

    try {
      final response = await model.generateContent([Content.text(prompt)]);

      // 1. TANGKAP BALASAN ASLI (Lihat di tab Debug Console nanti)
      final rawText = response.text;
      print("=== BALASAN ASLI GEMINI ===");
      print(rawText);
      print("===========================");

      if (rawText != null) {
        // 2. Bersihkan teks barangkali ada markdown ```json
        String cleanJson = rawText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        final Map<String, dynamic> data = jsonDecode(cleanJson);

        // 3. Cek apakah Gemini mengembalikan bungkus "nutrition" atau langsung isinya
        if (data.containsKey('nutrition')) {
          return data['nutrition'];
        } else {
          // Jika Gemini tidak memakai bungkus "nutrition", kembalikan data langsung
          return data;
        }
      }
    } catch (e) {
      // 4. PRINT ERROR JIKA GAGAL
      print("=== ERROR GEMINI ===");
      print(e.toString());
      print("====================");
      return null;
    }
    return null;
  }
}