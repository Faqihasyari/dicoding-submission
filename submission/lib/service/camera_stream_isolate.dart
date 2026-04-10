import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class CameraPlaneData {
  final Uint8List bytes;
  final int bytesPerRow;
  final int? bytesPerPixel;

  CameraPlaneData({
    required this.bytes,
    required this.bytesPerRow,
    required this.bytesPerPixel,
  });

  Map<String, dynamic> toMap() {
    return {
      'bytes': bytes,
      'bytesPerRow': bytesPerRow,
      'bytesPerPixel': bytesPerPixel,
    };
  }
}

class CameraPredictionResult {
  final int index;
  final double confidence;
  final bool isUint8;

  CameraPredictionResult({
    required this.index,
    required this.confidence,
    required this.isUint8,
  });
}

class CameraStreamIsolate {
  Isolate? _isolate;
  SendPort? _workerSendPort;

  Future<void> start(String modelPath) async {
    if (_isolate != null) return;

    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      _cameraStreamEntryPoint,
      {
        'replyPort': receivePort.sendPort,
        'modelPath': modelPath,
      },
    );

    _workerSendPort = await receivePort.first as SendPort;
  }

  Future<CameraPredictionResult> predict({
    required int width,
    required int height,
    required bool isBgra8888,
    required List<CameraPlaneData> planes,
  }) async {
    if (_workerSendPort == null) {
      throw StateError('Camera stream isolate is not started');
    }

    final responsePort = ReceivePort();

    _workerSendPort!.send({
      'type': 'predict',
      'width': width,
      'height': height,
      'isBgra8888': isBgra8888,
      'planes': planes.map((p) => p.toMap()).toList(),
      'replyPort': responsePort.sendPort,
    });

    final result = await responsePort.first as Map;
    responsePort.close();

    return CameraPredictionResult(
      index: result['index'] as int,
      confidence: (result['confidence'] as num).toDouble(),
      isUint8: result['isUint8'] as bool,
    );
  }

  void dispose() {
    _workerSendPort?.send({'type': 'dispose'});
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _workerSendPort = null;
  }
}

void _cameraStreamEntryPoint(Map<String, dynamic> init) {
  final mainSendPort = init['replyPort'] as SendPort;
  final modelPath = init['modelPath'] as String;

  final workerReceivePort = ReceivePort();
  mainSendPort.send(workerReceivePort.sendPort);

  final interpreter = Interpreter.fromFile(File(modelPath));

  workerReceivePort.listen((message) {
    if (message is! Map) return;

    final type = message['type'];

    if (type == 'dispose') {
      interpreter.close();
      workerReceivePort.close();
      return;
    }

    if (type != 'predict') return;

    final width = message['width'] as int;
    final height = message['height'] as int;
    final isBgra8888 = message['isBgra8888'] as bool;
    final planes = (message['planes'] as List).cast<Map>();
    final replyPort = message['replyPort'] as SendPort;

    try {
      final input = _preprocessImage(
        width: width,
        height: height,
        isBgra8888: isBgra8888,
        planes: planes,
      );

      final outputTensor = interpreter.getOutputTensor(0);
      final outputType = outputTensor.type;
      final classesCount = outputTensor.shape.last;

      int maxIndex = 0;
      num maxScore;

      if (outputType == TensorType.uint8) {
        final output = List.filled(classesCount, 0).reshape([1, classesCount]);
        interpreter.run(input, output);

        maxScore = output[0][0] as int;
        for (int i = 1; i < classesCount; i++) {
          final score = output[0][i] as int;
          if (score > maxScore) {
            maxScore = score;
            maxIndex = i;
          }
        }
      } else {
        final output =
            List.filled(classesCount, 0.0).reshape([1, classesCount]);
        interpreter.run(input, output);

        maxScore = output[0][0] as double;
        for (int i = 1; i < classesCount; i++) {
          final score = output[0][i] as double;
          if (score > maxScore) {
            maxScore = score;
            maxIndex = i;
          }
        }
      }

      replyPort.send({
        'index': maxIndex,
        'confidence': maxScore,
        'isUint8': outputType == TensorType.uint8,
      });
    } catch (_) {
      replyPort.send({
        'index': -1,
        'confidence': 0.0,
        'isUint8': false,
      });
    }
  });
}

List _preprocessImage({
  required int width,
  required int height,
  required bool isBgra8888,
  required List<Map> planes,
}) {
  final original = isBgra8888
      ? _convertBgra8888(width: width, height: height, planes: planes)
      : _convertYuv420(width: width, height: height, planes: planes);

  final resized = img.copyResize(original, width: 224, height: 224);

  return List.generate(
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
}

img.Image _convertBgra8888({
  required int width,
  required int height,
  required List<Map> planes,
}) {
  final plane = planes[0];
  final bytes = plane['bytes'] as Uint8List;
  final bytesPerRow = plane['bytesPerRow'] as int;

  final converted = img.Image(width: width, height: height);

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final index = y * bytesPerRow + x * 4;
      final b = bytes[index];
      final g = bytes[index + 1];
      final r = bytes[index + 2];
      converted.setPixelRgb(x, y, r, g, b);
    }
  }

  return converted;
}

img.Image _convertYuv420({
  required int width,
  required int height,
  required List<Map> planes,
}) {
  final yPlane = planes[0];
  final uPlane = planes[1];
  final vPlane = planes[2];

  final yBytes = yPlane['bytes'] as Uint8List;
  final uBytes = uPlane['bytes'] as Uint8List;
  final vBytes = vPlane['bytes'] as Uint8List;

  final yRowStride = yPlane['bytesPerRow'] as int;
  final uvRowStride = uPlane['bytesPerRow'] as int;
  final uvPixelStride = (uPlane['bytesPerPixel'] as int?) ?? 1;

  final converted = img.Image(width: width, height: height);

  for (int y = 0; y < height; y++) {
    final uvY = y ~/ 2;
    for (int x = 0; x < width; x++) {
      final uvX = x ~/ 2;

      final yIndex = y * yRowStride + x;
      final uvIndex = uvY * uvRowStride + uvX * uvPixelStride;

      final yValue = yBytes[yIndex];
      final uValue = uBytes[uvIndex];
      final vValue = vBytes[uvIndex];

      final r = (yValue + 1.402 * (vValue - 128)).round().clamp(0, 255);
      final g = (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128))
          .round()
          .clamp(0, 255);
      final b = (yValue + 1.772 * (uValue - 128)).round().clamp(0, 255);

      converted.setPixelRgb(x, y, r, g, b);
    }
  }

  return converted;
}
