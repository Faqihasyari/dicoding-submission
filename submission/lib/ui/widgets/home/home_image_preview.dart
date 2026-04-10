import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/controller/home_provider.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';
import 'package:provider/provider.dart';

class HomeImagePreview extends StatelessWidget {
  const HomeImagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        final imagePath = value.imagePath;
        return Container(
          height: 280,
          decoration: BoxDecoration(
            color: AppColors.softBeige,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.medBrown,
              width: 1.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: imagePath == null
              ? const _EmptyImagePlaceholder()
              : Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        );
      },
    );
  }
}

class _EmptyImagePlaceholder extends StatelessWidget {
  const _EmptyImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.cream,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.medBrown, width: 1.5),
            ),
            child: const Icon(
              Icons.image_outlined,
              size: 32,
              color: AppColors.mutedBrown,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap to add your food photo',
            style: GoogleFonts.playfairDisplay(
              fontSize: 14,
              color: AppColors.mutedBrown,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gallery, Camera, or Custom',
            style: GoogleFonts.lato(
              fontSize: 11,
              color: AppColors.medBrown,
            ),
          ),
        ],
      ),
    );
  }
}
