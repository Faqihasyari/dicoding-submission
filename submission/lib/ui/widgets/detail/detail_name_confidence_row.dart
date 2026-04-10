import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';

class DetailNameConfidenceRow extends StatelessWidget {
  final String result;
  final String confidence;

  const DetailNameConfidenceRow({
    super.key,
    required this.result,
    required this.confidence,
  });

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
              color: AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.softBeige,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderTan),
          ),
          child: Text(
            confidence,
            style: GoogleFonts.lato(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBrown,
            ),
          ),
        ),
      ],
    );
  }
}
