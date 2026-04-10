import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';

class DetailHeroImageSliver extends StatelessWidget {
  final String imagePath;

  const DetailHeroImageSliver({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.cream,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.cream.withAlpha(200),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderTan),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.deepBrown,
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
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.6, 1.0],
                    colors: [
                      Colors.transparent,
                      AppColors.cream,
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
