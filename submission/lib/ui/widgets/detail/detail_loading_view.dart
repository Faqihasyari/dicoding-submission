import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';

class DetailLoadingView extends StatelessWidget {
  const DetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.darkBrown,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: 16),
          Text(
            'Analyzing your food...',
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              color: AppColors.mutedBrown,
            ),
          ),
        ],
      ),
    );
  }
}
