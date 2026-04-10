import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';

class EmptyCard extends StatelessWidget {
  final String message;

  const EmptyCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.resultBorder),
      ),
      child: Text(
        message,
        style: GoogleFonts.lato(
          fontSize: 13,
          color: AppColors.mutedBrown,
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
      ),
    );
  }
}
