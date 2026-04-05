import 'package:chatbot_app/env/env.dart';
import 'package:googleai_dart/googleai_dart.dart';

class GeminiService {
  late final GoogleAI googleAI;

  GeminiService() {
    final apiKey = Env.geminiApiKey;

    googleAI = GoogleAI(apiKey: apiKey);
  }

  Future<String?> sendMessage(String message) async {
    final response = await googleAI.generateText(
      model: 'gemini-1.5-flash',
      prompt: message,
    );

    return response.text;
  }
}