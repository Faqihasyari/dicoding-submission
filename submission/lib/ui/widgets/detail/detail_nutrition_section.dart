import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';
import 'package:online_image_classification/ui/widgets/common/empty_card.dart';
import 'package:online_image_classification/ui/widgets/common/section_header.dart';

class DetailNutritionSection extends StatelessWidget {
  final Map<String, dynamic>? nutritionData;
  final String? errorMessage;

  const DetailNutritionSection({
    super.key,
    required this.nutritionData,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(icon: Icons.bar_chart_rounded, title: 'Nutrisi'),
        const SizedBox(height: 12),
        if (nutritionData == null)
          EmptyCard(
            message: errorMessage ??
                'Data nutrisi tidak tersedia atau gagal dimuat.',
          )
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.deepBrown,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department_rounded,
                    color: AppColors.lightTan, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kalori',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: AppColors.medBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${nutritionData!['calories']} kcal',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        color: AppColors.lightTan,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.resultBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.mutedBrown),
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
                    color: AppColors.mutedBrown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: AppColors.textDark,
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
