import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';
import 'package:online_image_classification/ui/widgets/common/empty_card.dart';
import 'package:online_image_classification/ui/widgets/common/section_header.dart';

class DetailRecipeSection extends StatelessWidget {
  final Map<String, dynamic>? mealData;
  final String result;
  final String? errorMessage;

  const DetailRecipeSection({
    super.key,
    required this.mealData,
    required this.result,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(icon: Icons.menu_book_rounded, title: 'Resep'),
        const SizedBox(height: 12),
        if (mealData == null)
          EmptyCard(
            message: errorMessage ??
                "Resep untuk '$result' tidak ditemukan di database TheMealDB.",
          )
        else ...[
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.warmWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.resultBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instruksi Memasak',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  mealData!['strInstructions'] ?? 'Tidak ada instruksi.',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    height: 1.7,
                    color: AppColors.darkBrown,
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
