import 'dart:io';

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
          child: _Body()),
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
                      final image = await context
                          .read<CameraProvider>()
                          .takePicture();

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
