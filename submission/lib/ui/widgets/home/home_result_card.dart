import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/controller/home_provider.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';
import 'package:provider/provider.dart';

class HomeResultCard extends StatelessWidget {
  const HomeResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        final hasResult = value.result.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.warmWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.resultBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.lightTan,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 18,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result',
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        color: AppColors.mutedBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasResult ? value.result : 'Waiting for analysis...',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 15,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
