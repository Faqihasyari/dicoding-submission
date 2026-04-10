import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/controller/home_provider.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';
import 'package:provider/provider.dart';

class HomeActionButtons extends StatelessWidget {
  const HomeActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: Icons.photo_library_outlined,
          label: 'Gallery',
          onTap: () => context.read<HomeProvider>().openGallery(),
        ),
        const SizedBox(width: 10),
        _ActionButton(
          icon: Icons.camera_alt_outlined,
          label: 'Camera',
          onTap: () => context.read<HomeProvider>().openCamera(),
        ),
        const SizedBox(width: 10),
        _ActionButton(
          icon: Icons.photo_camera_back_outlined,
          label: 'Custom',
          onTap: () => context.read<HomeProvider>().openCustomCamera(context),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderTan, width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.softBeige,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: AppColors.darkBrown),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.lato(
                  fontSize: 11,
                  color: AppColors.darkBrown,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
