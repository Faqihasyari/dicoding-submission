import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../model/auth_response.dart';
import '../model/story.dart';

class ApiService {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
      return loginResponse.loginResult.token;
    } else {
      final errorData = CommonResponse.fromJson(jsonDecode(response.body));
      throw Exception(errorData.message);
    }
  }

  Future<void> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      final errorData = CommonResponse.fromJson(jsonDecode(response.body));
      throw Exception(errorData.message);
    }
  }

  Future<StoryResponse> getStories(String token, {int page = 1, int size = 10}) async {

    final response = await http.get(
      Uri.parse('$baseUrl/stories?page=$page&size=$size'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return StoryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat daftar cerita');
    }
  }

  Future<void> addStory(
    String token,
    String description,
    List<int> bytes,
    String fileName, {
        double? lat,
        double? lon,
      }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/stories'),
    );

    final multipartFile = http.MultipartFile.fromBytes(
      'photo',
      bytes,
      filename: fileName,
    );

    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-type": "multipart/form-data",
    };

    request.files.add(multipartFile);
    request.fields.addAll({'description': description});
    request.headers.addAll(headers);

    if (lat != null && lon != null) {
      request.fields['lat'] = lat.toString();
      request.fields['lon'] = lon.toString();
    }

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode != 201) {
      final errorData = jsonDecode(responseData);
      throw Exception(errorData['message'] ?? 'Gagal mengunggah cerita');
    }
  }
}
