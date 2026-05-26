import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../core/config.dart';

class ApiClient {
  static final GetStorage _storage = GetStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // ---------------------------------------------------------------------------
  // Token management
  // ---------------------------------------------------------------------------

  static String? getAccessToken() => _storage.read<String>(_accessTokenKey);

  static String? getRefreshToken() => _storage.read<String>(_refreshTokenKey);

  static void saveTokens(String accessToken, String refreshToken) {
    _storage.write(_accessTokenKey, accessToken);
    _storage.write(_refreshTokenKey, refreshToken);
  }

  static void clearTokens() {
    _storage.remove(_accessTokenKey);
    _storage.remove(_refreshTokenKey);
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  Map<String, String> _buildHeaders({bool authenticated = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authenticated) {
      final token = getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Uri _buildUri(String endpoint) {
    return Uri.parse('${AppConfig.baseUrl}$endpoint');
  }

  Future<Map<String, dynamic>> _processResponse(http.Response response) async {
    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode == 401) {
      clearTokens();
      return {
        'error': true,
        'statusCode': 401,
        'message': body['detail'] ?? 'Unauthorized',
      };
    }

    if (response.statusCode >= 400) {
      return {
        'error': true,
        'statusCode': response.statusCode,
        'message': body['detail'] ?? body['message'] ?? 'Request failed',
      };
    }

    return {
      'error': false,
      'statusCode': response.statusCode,
      'data': body,
    };
  }

  // ---------------------------------------------------------------------------
  // Public HTTP methods
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool authenticated = true,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final headers = _buildHeaders(authenticated: authenticated);
      final response = await http
          .get(uri, headers: headers)
          .timeout(AppConfig.requestTimeout);
      return _processResponse(response);
    } catch (e) {
      return {
        'error': true,
        'statusCode': 0,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final headers = _buildHeaders(authenticated: authenticated);
      final response = await http
          .post(uri, headers: headers, body: body != null ? jsonEncode(body) : null)
          .timeout(AppConfig.requestTimeout);
      return _processResponse(response);
    } catch (e) {
      return {
        'error': true,
        'statusCode': 0,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final headers = _buildHeaders(authenticated: authenticated);
      final response = await http
          .put(uri, headers: headers, body: body != null ? jsonEncode(body) : null)
          .timeout(AppConfig.requestTimeout);
      return _processResponse(response);
    } catch (e) {
      return {
        'error': true,
        'statusCode': 0,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final headers = _buildHeaders(authenticated: authenticated);
      final response = await http
          .patch(uri, headers: headers, body: body != null ? jsonEncode(body) : null)
          .timeout(AppConfig.requestTimeout);
      return _processResponse(response);
    } catch (e) {
      return {
        'error': true,
        'statusCode': 0,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool authenticated = true,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final headers = _buildHeaders(authenticated: authenticated);
      final response = await http
          .delete(uri, headers: headers)
          .timeout(AppConfig.requestTimeout);
      return _processResponse(response);
    } catch (e) {
      return {
        'error': true,
        'statusCode': 0,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}