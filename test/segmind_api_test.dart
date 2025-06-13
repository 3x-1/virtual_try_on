import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:virtual_try_on/services/segmind_api.dart';

void main() {
  test('callTryOnDiffusion returns bytes on success', () async {
    final outputBytes = Uint8List.fromList([1, 2, 3]);
    final client = MockClient((request) async {
      expect(request.method, equals('POST'));
      final body = jsonEncode({'output': base64Encode(outputBytes)});
      return http.Response(body, 200);
    });

    final result = await callTryOnDiffusion(
      userBase64: 'user',
      clothingBase64: 'clothing',
      apiKey: 'key',
      client: client,
    );

    expect(result, equals(outputBytes));
  });
}
