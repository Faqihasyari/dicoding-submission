import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.cream,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 24,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHAT\'S ON YOUR PLATE?',
            style: GoogleFonts.lato(
              fontSize: 11,
              color: AppColors.mutedBrown,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Food Recognizer',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      toolbarHeight: 72,
    );
  }
}
