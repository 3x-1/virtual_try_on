// lib/services/segmind_api.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<Uint8List?> callTryOnDiffusion({
  required String userBase64,
  required String clothingBase64,
  required String apiKey,
  http.Client? client,
}) async {
  final uri = Uri.parse('https://api.segmind.com/v1/tryon-diffusion');

  final body = jsonEncode({
    "inputs": {
      "image": userBase64,
      "clothing": clothingBase64,
    }
  });

  final httpClient = client ?? http.Client();
  try {
    final response = await httpClient.post(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final base64Result = jsonMap['output'];
      return base64Decode(base64Result);
    } else {
      print('Segmind error: ${response.statusCode}');
      print(response.body);
      return null;
    }
  } finally {
    if (client == null) {
      httpClient.close();
    }
  }
}
