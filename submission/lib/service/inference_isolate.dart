import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

Future<Map<String, dynamic>> runInferenceIsolate(Map<String, dynamic> data) async {
  final modelPath = data['modelPath'];
  final imagePath = data['imagePath'];

  final interpreter = Interpreter.fromFile(File(modelPath));

  final image = img.decodeImage(File(imagePath).readAsBytesSync())!;
  final resized = img.copyResize(image, width: 224, height: 224);

  final input = List.generate(
    1,
        (_) => List.generate(
      224,
          (y) => List.generate(
        224,
            (x) {
          final pixel = resized.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    ),
  );

  var output = List.filled(1 * 2024, 0).reshape([1, 2024]);

  interpreter.run(input, output);

  final result = output[0];

  int maxIndex = 0;
  int maxScore = 0;

  for (int i = 0; i < result.length; i++) {
    if (result[i] > maxScore) {
      maxScore = result[i];
      maxIndex = i;
    }
  }

  return {
    "index": maxIndex,
    "confidence": maxScore,
  };
}