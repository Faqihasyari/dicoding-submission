import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controller/detail_porvider.dart';

// ── Color palette (sama dengan HomePage) ──────────────────────────────────────
class _AppColors {
  static const cream = Color(0xFFFBF7F2);
  static const softBeige = Color(0xFFF0E8DF);
  static const lightTan = Color(0xFFF5E0C8);
  static const borderTan = Color(0xFFDCC5A8);
  static const mutedBrown = Color(0xFFA0856A);
  static const medBrown = Color(0xFFC8A98A);
  static const darkBrown = Color(0xFF6B4226);
  static const deepBrown = Color(0xFF3D2010);
  static const textDark = Color(0xFF2D1F14);
  static const warmWhite = Color(0xFFFFF8F0);
  static const resultBorder = Color(0xFFEDD9C0);
}

class DetailPage extends StatelessWidget {
  final String imagePath;
  final String result;
  final String confidence;

  const DetailPage({
    super.key,
    required this.imagePath,
    required this.result,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailProvider()..loadData(result),
      child: _DetailView(
        imagePath: imagePath,
        result: result,
        confidence: confidence,
      ),
    );
  }
}

class _DetailView extends StatelessWidget {
  final String imagePath;
  final String result;
  final String confidence;

  const _DetailView({
    required this.imagePath,
    required this.result,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.cream,
      body: Consumer<DetailProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const _LoadingView();
          }

          return CustomScrollView(
            slivers: [
              // ── Hero image + back button ─────────────────────────────────
              _HeroImageSliver(imagePath: imagePath),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Name + confidence badge ──────────────────────────
                      _NameConfidenceRow(result: result, confidence: confidence),
                      const SizedBox(height: 20),

                      // ── Nutrition section ────────────────────────────────
                      _NutritionSection(nutritionData: value.nutritionData),
                      const SizedBox(height: 20),

                      // ── Recipe section ───────────────────────────────────
                      _RecipeSection(mealData: value.mealData, result: result),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Loading ────────────────────────────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: _AppColors.darkBrown,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: 16),
          Text(
            'Analyzing your food...',
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              color: _AppColors.mutedBrown,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero Image Sliver ──────────────────────────────────────────────────────────
class _HeroImageSliver extends StatelessWidget {
  final String imagePath;

  const _HeroImageSliver({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: _AppColors.cream,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _AppColors.cream.withOpacity(0.9),
            shape: BoxShape.circle,
            border: Border.all(color: _AppColors.borderTan),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: _AppColors.deepBrown,
            size: 20,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
            // Gradient fade at the bottom
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.6, 1.0],
                    colors: [
                      Colors.transparent,
                      _AppColors.cream,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Name + Confidence ──────────────────────────────────────────────────────────
class _NameConfidenceRow extends StatelessWidget {
  final String result;
  final String confidence;

  const _NameConfidenceRow({required this.result, required this.confidence});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            result,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: _AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _AppColors.softBeige,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _AppColors.borderTan),
          ),
          child: Text(
            confidence,
            style: GoogleFonts.lato(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _AppColors.darkBrown,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Nutrition Section ──────────────────────────────────────────────────────────
class _NutritionSection extends StatelessWidget {
  final Map<String, dynamic>? nutritionData;

  const _NutritionSection({required this.nutritionData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(icon: Icons.bar_chart_rounded, title: 'Nutrisi'),
        const SizedBox(height: 12),

        if (nutritionData == null)
          _EmptyCard(message: 'Data nutrisi tidak tersedia atau gagal dimuat.')
        else ...[
          if (nutritionData!['calories'] == 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 14, color: Color(0xFFBA7517)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'API Key terkena limit kuota. Menampilkan UI cadangan.',
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        color: const Color(0xFFBA7517),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Calories highlight card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: _AppColors.deepBrown,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department_rounded,
                    color: _AppColors.lightTan, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kalori',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: _AppColors.medBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${nutritionData!['calories']} kcal',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        color: _AppColors.lightTan,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Other nutrients in a 2-column grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.4,
            children: [
              _NutrientCard(
                icon: Icons.grain_rounded,
                label: 'Karbohidrat',
                value: '${nutritionData!['carbs']} g',
              ),
              _NutrientCard(
                icon: Icons.fitness_center_rounded,
                label: 'Protein',
                value: '${nutritionData!['protein']} g',
              ),
              _NutrientCard(
                icon: Icons.water_drop_outlined,
                label: 'Lemak',
                value: '${nutritionData!['fat']} g',
              ),
              _NutrientCard(
                icon: Icons.eco_outlined,
                label: 'Serat',
                value: '${nutritionData!['fiber']} g',
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _NutrientCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _NutrientCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _AppColors.warmWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _AppColors.resultBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _AppColors.mutedBrown),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    color: _AppColors.mutedBrown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: _AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recipe Section ─────────────────────────────────────────────────────────────
class _RecipeSection extends StatelessWidget {
  final Map<String, dynamic>? mealData;
  final String result;

  const _RecipeSection({required this.mealData, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(icon: Icons.menu_book_rounded, title: 'Resep'),
        const SizedBox(height: 12),

        if (mealData == null)
          _EmptyCard(
            message: "Resep untuk '$result' tidak ditemukan di database TheMealDB.",
          )
        else ...[
          // Meal thumbnail from API
          if (mealData!['strMealThumb'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                mealData!['strMealThumb']!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 16),

          // Instructions card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _AppColors.warmWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _AppColors.resultBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instruksi Memasak',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  mealData!['strInstructions'] ?? 'Tidak ada instruksi.',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    height: 1.7,
                    color: _AppColors.darkBrown,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ── Shared Widgets ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _AppColors.softBeige,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: _AppColors.darkBrown),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _AppColors.warmWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _AppColors.resultBorder),
      ),
      child: Text(
        message,
        style: GoogleFonts.lato(
          fontSize: 13,
          color: _AppColors.mutedBrown,
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
      ),
    );
  }
}