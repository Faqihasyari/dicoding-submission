import 'dart:io';
import 'package:image/image.dart' as img;

List preprocessImage(File imageFile) {
  final image = img.decodeImage(imageFile.readAsBytesSync())!;
  final resized = img.copyResize(image, width: 224, height: 224);

  return List.generate(
    1,
        (_) => List.generate(
      224,
          (y) => List.generate(
        224,
            (x) {
          final pixel = resized.getPixel(x, y);

          return [
            pixel.r ,
            pixel.g,
            pixel.b,
          ];
        },
      ),
    ),
  );
}