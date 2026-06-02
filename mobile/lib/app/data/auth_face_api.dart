import 'dart:convert';
import 'dart:typed_data';
import 'api_client.dart';

class AuthFaceApi {
  final ApiClient _client = ApiClient();

  /// POST /auth/face/register
  /// Uploads a face image (base64) to register the caregiver's face.
  Future<Map<String, dynamic>> registerFace({
    required Uint8List imageBytes,
  }) async {
    final base64Image = base64Encode(imageBytes);

    final response = await _client.post(
      '/auth/face/register',
      body: {
        'base64_image': base64Image,
      },
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// POST /auth/face/verify
  /// Uploads a face image (base64) to verify against registered embedding.
  Future<Map<String, dynamic>> verifyFace({
    required Uint8List imageBytes,
  }) async {
    final base64Image = base64Encode(imageBytes);

    final response = await _client.post(
      '/auth/face/verify',
      body: {
        'base64_image': base64Image,
      },
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// GET /auth/face/status
  /// Returns whether the current user has a registered face.
  Future<Map<String, dynamic>> faceStatus() async {
    final response = await _client.get(
      '/auth/face/status',
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }
}
