import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/controller/home_provider.dart';
import 'package:online_image_classification/ui/detail_page.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';
import 'package:provider/provider.dart';

class HomeAnalyzeButton extends StatelessWidget {
  const HomeAnalyzeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: provider.isAnalyzing
              ? null
              : () async {
                  final isSuccess = await provider.analyzeImage();
                  if (!context.mounted ||
                      !isSuccess ||
                      provider.imagePath == null) {
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(
                        imagePath: provider.imagePath!,
                        result: provider.predictedName,
                        confidence: provider.confidenceString,
                      ),
                    ),
                  );
                },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.deepBrown,
              borderRadius: BorderRadius.circular(16),
            ),
            child: provider.isAnalyzing
                ? const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColors.lightTan,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: AppColors.lightTan,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Analyze Food',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          color: AppColors.lightTan,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
