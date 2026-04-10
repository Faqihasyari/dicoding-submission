import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteService {
  Interpreter? interpreter;

  Future<void> loadModel(File modelFile) async {
    interpreter = Interpreter.fromFile(modelFile);
  }

  List<double> runInference(List input) {
    var output = List.filled(1 * 10, 0.0).reshape([1, 10]);

    interpreter!.run(input, output);

    return output[0];
  }
}
