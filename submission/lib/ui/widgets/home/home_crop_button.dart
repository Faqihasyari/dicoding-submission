import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/controller/home_provider.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';
import 'package:provider/provider.dart';

class HomeCropButton extends StatelessWidget {
  const HomeCropButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<HomeProvider>().cropImage(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.softBeige,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderTan, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.crop_rounded,
                size: 18, color: AppColors.darkBrown),
            const SizedBox(width: 8),
            Text(
              'Crop Image',
              style: GoogleFonts.lato(
                fontSize: 13,
                color: AppColors.darkBrown,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
