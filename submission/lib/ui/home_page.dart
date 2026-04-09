import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_image_classification/controller/home_provider.dart';
import 'package:online_image_classification/util/widgets_extension.dart';
import 'package:provider/provider.dart';

import 'detail_page.dart';

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
      appBar: AppBar(
        title: Text("Online Image Classification"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 4,
            children: [
              Expanded(
                child: Consumer<HomeProvider>(
                  builder: (context, value, child) {
                    final imagePath = value.imagePath;
                    return imagePath == null
                        ? const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image,
                              size: 100,
                            ),
                          )
                        : Image.file(
                            File(imagePath.toString()),
                            fit: BoxFit.contain,
                          );
                  },
                ),
              ),
              Consumer<HomeProvider>(
                builder: (context, value, child) {
                  if (value.result.isEmpty) return const SizedBox();

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      value.result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            context.read<HomeProvider>().openGallery(),
                        child: const Text("Gallery"),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<HomeProvider>().openCamera(),
                        child: const Text("Camera"),
                      ),
                      ElevatedButton(
                        onPressed: () => context
                            .read<HomeProvider>()
                            .openCustomCamera(context),
                        child: const Text(
                          "Custom Camera",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => context.read<HomeProvider>().cropImage(),
                        child: Text("Crop"),
                      ),
                    ].expanded(),
                  ),
                  FilledButton.tonal(
                    onPressed: () async {
                      final provider = context.read<HomeProvider>();
                      await provider.analyzeImage();
                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(
                            imagePath: provider.imagePath!,
                            // 1. Kirim HANYA NAMA untuk API
                            result: provider.predictedName,
                            // 2. Kirim PERSENTASE untuk UI
                            confidence: provider.confidenceString,
                          ),
                        ),
                      );
                    },
                    child: const Text("Analyze"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
