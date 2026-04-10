import 'package:flutter/material.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';
import 'package:online_image_classification/ui/widgets/detail/detail_hero_image_sliver.dart';
import 'package:online_image_classification/ui/widgets/detail/detail_loading_view.dart';
import 'package:online_image_classification/ui/widgets/detail/detail_name_confidence_row.dart';
import 'package:online_image_classification/ui/widgets/detail/detail_nutrition_section.dart';
import 'package:online_image_classification/ui/widgets/detail/detail_recipe_section.dart';
import 'package:provider/provider.dart';

import '../controller/detail_porvider.dart';

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
      backgroundColor: AppColors.cream,
      body: Consumer<DetailProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const DetailLoadingView();
          }

          return CustomScrollView(
            slivers: [
              DetailHeroImageSliver(imagePath: imagePath),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailNameConfidenceRow(
                          result: result, confidence: confidence),
                      const SizedBox(height: 20),
                      DetailNutritionSection(
                        nutritionData: value.nutritionData,
                        errorMessage: value.nutritionErrorMessage,
                      ),
                      const SizedBox(height: 20),
                      DetailRecipeSection(
                        mealData: value.mealData,
                        result: result,
                        errorMessage: value.mealErrorMessage,
                      ),
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
