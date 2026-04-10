import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../env/env.dart';

class GeminiService {
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
      final response = await model.generateContent(
          [Content.text(prompt)]).timeout(const Duration(seconds: 20));

      final rawText = response.text;

      if (rawText != null) {
        String cleanJson =
            rawText.replaceAll('```json', '').replaceAll('```', '').trim();

        final Map<String, dynamic> data = jsonDecode(cleanJson);

        if (data.containsKey('nutrition')) {
          return data['nutrition'];
        } else {
          return data;
        }
      }
      throw Exception('Respons nutrisi tidak valid dari Gemini.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet untuk memuat data nutrisi.');
    } on TimeoutException {
      throw Exception('Permintaan data nutrisi terlalu lama. Coba lagi.');
    } catch (_) {
      throw Exception('Gagal memuat data nutrisi dari Gemini.');
    }
  }
}
