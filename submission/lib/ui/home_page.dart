import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/controller/home_provider.dart';
import 'package:online_image_classification/util/widgets_extension.dart';
import 'package:provider/provider.dart';

import 'detail_page.dart';

// ── Color palette ──────────────────────────────────────────────────────────────
class _AppColors {
  static const cream = Color(0xFFFBF7F2);
  static const softBeige = Color(0xFFF0E8DF);
  static const lightTan = Color(0xFFF5E0C8);
  static const borderTan = Color(0xFFDCC5A8);
  static const mutedBrown = Color(0xFFA0856A);
  static const medBrown = Color(0xFFC8A98A);
  static const darkBrown = Color(0xFF6B4226);
  static const deepBrown = Color(0xFF3D2010);
  static const textDark = Color(0xFF2D1F14);
  static const warmWhite = Color(0xFFFFF8F0);
  static const resultBorder = Color(0xFFEDD9C0);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.cream,
      appBar: _buildAppBar(),
      body: const _HomeBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _AppColors.cream,
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
              color: _AppColors.mutedBrown,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Food Recognizer',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              color: _AppColors.textDark,
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

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image preview ─────────────────────────────────────────────
            _ImagePreview(),
            const SizedBox(height: 16),

            // ── Result card ───────────────────────────────────────────────
            _ResultCard(),
            const SizedBox(height: 16),

            // ── Action buttons: Gallery | Camera | Custom ─────────────────
            _ActionButtonsRow(),
            const SizedBox(height: 10),

            // ── Crop button ───────────────────────────────────────────────
            _CropButton(),
            const SizedBox(height: 16),

            // ── Analyze CTA ───────────────────────────────────────────────
            _AnalyzeButton(),
          ],
        ),
      ),
    );
  }
}

// ── Image Preview ──────────────────────────────────────────────────────────────
class _ImagePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        final imagePath = value.imagePath;
        return Container(
          height: 280,
          decoration: BoxDecoration(
            color: _AppColors.softBeige,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _AppColors.medBrown,
              width: 1.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: imagePath == null
              ? _EmptyImagePlaceholder()
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
              color: _AppColors.cream,
              shape: BoxShape.circle,
              border: Border.all(color: _AppColors.medBrown, width: 1.5),
            ),
            child: const Icon(
              Icons.image_outlined,
              size: 32,
              color: _AppColors.mutedBrown,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap to add your food photo',
            style: GoogleFonts.playfairDisplay(
              fontSize: 14,
              color: _AppColors.mutedBrown,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gallery, Camera, or Custom',
            style: GoogleFonts.lato(
              fontSize: 11,
              color: _AppColors.medBrown,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Result Card ────────────────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        final hasResult = value.result.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _AppColors.warmWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _AppColors.resultBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: _AppColors.lightTan,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 18,
                  color: _AppColors.darkBrown,
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
                        color: _AppColors.mutedBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasResult ? value.result : 'Waiting for analysis...',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 15,
                        color: _AppColors.textDark,
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

// ── Action Buttons Row ─────────────────────────────────────────────────────────
class _ActionButtonsRow extends StatelessWidget {
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
            color: _AppColors.cream,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _AppColors.borderTan, width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _AppColors.softBeige,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: _AppColors.darkBrown),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.lato(
                  fontSize: 11,
                  color: _AppColors.darkBrown,
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

// ── Crop Button ────────────────────────────────────────────────────────────────
class _CropButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<HomeProvider>().cropImage(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: _AppColors.softBeige,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _AppColors.borderTan, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.crop_rounded, size: 18, color: _AppColors.darkBrown),
            const SizedBox(width: 8),
            Text(
              'Crop Image',
              style: GoogleFonts.lato(
                fontSize: 13,
                color: _AppColors.darkBrown,
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

// ── Analyze Button ─────────────────────────────────────────────────────────────
class _AnalyzeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () async {
            await provider.analyzeImage();
            if (!context.mounted) return;
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
              color: _AppColors.deepBrown,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: _AppColors.lightTan,
                ),
                const SizedBox(width: 10),
                Text(
                  'Analyze Food',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    color: _AppColors.lightTan,
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