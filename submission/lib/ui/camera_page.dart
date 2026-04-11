import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:online_image_classification/controller/camera_provider.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: ChangeNotifierProvider(
          create: (context) => CameraProvider()..initCamera(),
          child: const _Body()),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CameraProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                provider.isCameraInitialized
                    ? CameraPreview(provider.controller!)
                    : const CircularProgressIndicator(),
                Align(
                  alignment: const Alignment(0, -0.92),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          provider.isModelReady
                              ? 'Deteksi kamera aktif'
                              : 'Menyiapkan model... ',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          provider.liveResult,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (provider.errorMessage != null)
                  Align(
                    alignment: const Alignment(0, -0.74),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xAA8E2D2D),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              provider.errorMessage!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => provider.clearError(),
                            child: const Icon(Icons.close,
                                size: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                Align(
                  alignment: const Alignment(0.9, 0.9),
                  child: FloatingActionButton(
                    heroTag: "switch-camera",
                    onPressed: () =>
                        context.read<CameraProvider>().switchCamera(),
                    child: const Icon(Icons.cameraswitch),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0.9),
                  child: FloatingActionButton(
                    heroTag: "capture-image",
                    onPressed: () async {
                      final image =
                          await context.read<CameraProvider>().takePicture();

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, image);
                    },
                    child: const Icon(Icons.camera_alt_outlined),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
