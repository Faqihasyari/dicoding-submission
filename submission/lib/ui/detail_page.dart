import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pastikan import ini sesuai dengan nama file-mu
import '../controller/detail_porvider.dart';

class DetailPage extends StatelessWidget {
  final String imagePath;
  final String result;
  final String confidence; // 🔥 Tambahan Baru


  const DetailPage({
    super.key,
    required this.imagePath,
    required this.result,
    required this.confidence, // 🔥 Tambahan Baru
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailProvider()..loadData(result),
      // Jangan lupa kirimkan juga ke _DetailView
      child: _DetailView(imagePath: imagePath, result: result, confidence: confidence),
    );
  }
}

// 🔥 PERBAIKAN: Tambahkan variabel confidence di class _DetailView
class _DetailView extends StatelessWidget {
  final String imagePath;
  final String result;
  final String confidence; // 1. Tambahkan baris ini

  const _DetailView({
    required this.imagePath,
    required this.result,
    required this.confidence, // 2. Tambahkan baris ini di dalam constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Makanan")),
      body: Consumer<DetailProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. GAMBAR JEPRETAN PENGGUNA
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 16),

                // 🔥 PERBAIKAN 3: UI untuk Nama Makanan & Confidence Score
                // Ubah Text biasa menjadi Row agar bersebelahan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      result, // Menampilkan nama (contoh: "Sushi")
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        confidence, // Menampilkan persentase (contoh: "83.53%")
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32, thickness: 2),

                // 3. BAGIAN MEAL DB
                if (value.mealData == null) ...[
                  Text(
                    "Resep untuk '$result' tidak ditemukan di database TheMealDB.",
                    style: const TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
                  ),
                ] else ...[
                  if (value.mealData!['strMealThumb'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        value.mealData!['strMealThumb']!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    "Instruksi Memasak:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value.mealData!['strInstructions'] ?? 'Tidak ada instruksi.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],

                const Divider(height: 32, thickness: 2),

                // 4. BAGIAN GEMINI (NUTRISI)
                const Text(
                  "Nutrisi (Dari Gemini):",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                if (value.nutritionData != null) ...[
                  // Opsional: Pesan error jika API terkena limit (dummy data)
                  if (value.nutritionData!['calories'] == 0)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                          "Catatan: API Key terkena limit kuota. Menampilkan UI cadangan.",
                          style: TextStyle(color: Colors.orange, fontStyle: FontStyle.italic, fontSize: 12)
                      ),
                    ),

                  _buildNutritionRow("Kalori", "${value.nutritionData!['calories']} kcal"),
                  _buildNutritionRow("Karbohidrat", "${value.nutritionData!['carbs']} g"),
                  _buildNutritionRow("Protein", "${value.nutritionData!['protein']} g"),
                  _buildNutritionRow("Lemak", "${value.nutritionData!['fat']} g"),
                  _buildNutritionRow("Serat", "${value.nutritionData!['fiber']} g"),
                ] else ...[
                  const Text("Data nutrisi tidak tersedia atau gagal dimuat."),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// (Fungsi _buildNutritionRow tetap dibiarkan di bawah luar class seperti sebelumnya)

Widget _buildNutritionRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
