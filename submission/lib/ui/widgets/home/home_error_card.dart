import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_image_classification/controller/home_provider.dart';
import 'package:provider/provider.dart';

class HomeErrorCard extends StatelessWidget {
  const HomeErrorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final message = provider.errorMessage;
        if (message == null || message.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF2F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1B5B5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 18, color: Color(0xFFB54747)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: const Color(0xFF8E2D2D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: provider.clearError,
                child:
                    const Icon(Icons.close, size: 16, color: Color(0xFF8E2D2D)),
              ),
            ],
          ),
        );
      },
    );
  }
}
