import 'package:envied/envied.dart';

part 'env.g.dart'; // File ini akan error merah, biarkan saja dulu!

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GEMINI_API_KEY', obfuscate: true)
  static final String apiKey = _Env.apiKey;
}