import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../core/config.dart';
import '../core/logger.dart';

class ApiClient {
  static final GetStorage _storage = GetStorage();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  static String? _accessToken;
  static String? _refreshToken;

  bool _isRefreshing = false;

  // ---------------------------------------------------------------------------
  // Token management
  // ---------------------------------------------------------------------------

  static Future<void> initTokenStorage() async {
    _accessToken = await _secureStorage.read(key: _accessTokenKey);
    _refreshToken = await _secureStorage.read(key: _refreshTokenKey);
  }

  static String? getAccessToken() => _accessToken;

  static String? getRefreshToken() => _refreshToken;

  static Future<void> saveTokens(
    String accessToken,
    String refreshToken,
  ) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  static Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
    ]);
  }

  /// Clears non-sensitive cached state and secure authentication tokens.
  static void clearAllStorage() {
    _storage.erase();
    unawaited(clearTokens());
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  Map<String, String> _buildHeaders({bool authenticated = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
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

  /// Attempt to refresh the JWT token.
  /// Returns true if refresh succeeded and tokens were updated.
  Future<bool> _tryRefreshToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      final currentRefreshToken = getRefreshToken();
      if (currentRefreshToken == null) return false;

      final uri = _buildUri('/auth/refresh');
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode({'refresh_token': currentRefreshToken}),
          )
          .timeout(AppConfig.requestTimeout);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final newAccess = body['access_token'] as String?;
        final newRefresh = body['refresh_token'] as String?;
        if (newAccess != null && newRefresh != null) {
          await saveTokens(newAccess, newRefresh);
          return true;
        }
      }

      // Refresh failed — clear everything
      await clearTokens();
      return false;
    } catch (_) {
      await clearTokens();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Map<String, dynamic>> _processResponse(
    http.Response response, {
    bool retried = false,
  }) async {
    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode == 401 && !retried) {
      // Try refresh before giving up
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        // Return a special signal so the caller knows to retry
        return {
          'error': false,
          'statusCode': 498, // custom: token refreshed
          'message': 'Token refreshed, retry the request',
        };
      }
      // Refresh failed — caller should redirect to login
      return {
        'error': true,
        'statusCode': 401,
        'message': body['detail'] ?? 'Sesi habis. Silakan login ulang.',
        'session_expired': true,
      };
    }

    if (response.statusCode >= 400) {
      final message = body['detail'] ?? body['message'] ?? 'Permintaan gagal';
      log.api(
        '?',
        response.request?.url.toString() ?? '',
        response.statusCode,
        response: body,
      );
      return {
        'error': true,
        'statusCode': response.statusCode,
        'message': message,
        'detail_body': body, // keep raw body for rich error display
      };
    }

    return {'error': false, 'statusCode': response.statusCode, 'data': body};
  }

  /// Retry a request after token refresh by rebuilding headers.
  Future<Map<String, dynamic>> _retryAuthenticated(
    Future<http.Response> Function(Map<String, String> headers) request,
  ) async {
    final newToken = getAccessToken();
    if (newToken == null) {
      return {
        'error': true,
        'statusCode': 401,
        'message': 'Sesi habis. Silakan login ulang.',
        'session_expired': true,
      };
    }

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      'Authorization': 'Bearer $newToken',
    };

    try {
      final response = await request(headers).timeout(AppConfig.requestTimeout);
      return _processResponse(response, retried: true);
    } catch (e) {
      return {
        'error': true,
        'statusCode': 0,
        'message': 'Network error: ${e.toString()}',
      };
    }
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
      log.api('GET', endpoint, null);
      final response = await http
          .get(uri, headers: headers)
          .timeout(AppConfig.requestTimeout);

      final processed = await _processResponse(response);
      log.api('GET', endpoint, response.statusCode);

      // If token was refreshed, retry the original request
      if (processed['statusCode'] == 498 && authenticated) {
        return _retryAuthenticated(
          (newHeaders) => http.get(uri, headers: newHeaders),
        );
      }

      return processed;
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
      log.api('POST', endpoint, null, request: body);
      final response = await http
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConfig.requestTimeout);

      final processed = await _processResponse(response);
      log.api('POST', endpoint, response.statusCode);

      if (processed['statusCode'] == 498 && authenticated) {
        return _retryAuthenticated(
          (newHeaders) => http.post(
            uri,
            headers: newHeaders,
            body: body != null ? jsonEncode(body) : null,
          ),
        );
      }

      return processed;
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
      log.api('PUT', endpoint, null, request: body);
      final response = await http
          .put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConfig.requestTimeout);

      final processed = await _processResponse(response);
      log.api('PUT', endpoint, response.statusCode);

      if (processed['statusCode'] == 498 && authenticated) {
        return _retryAuthenticated(
          (newHeaders) => http.put(
            uri,
            headers: newHeaders,
            body: body != null ? jsonEncode(body) : null,
          ),
        );
      }

      return processed;
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
      log.api('PATCH', endpoint, null, request: body);
      final response = await http
          .patch(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConfig.requestTimeout);

      final processed = await _processResponse(response);
      log.api('PATCH', endpoint, response.statusCode);

      if (processed['statusCode'] == 498 && authenticated) {
        return _retryAuthenticated(
          (newHeaders) => http.patch(
            uri,
            headers: newHeaders,
            body: body != null ? jsonEncode(body) : null,
          ),
        );
      }

      return processed;
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
      log.api('DELETE', endpoint, null);
      final response = await http
          .delete(uri, headers: headers)
          .timeout(AppConfig.requestTimeout);

      final processed = await _processResponse(response);
      log.api('DELETE', endpoint, response.statusCode);

      if (processed['statusCode'] == 498 && authenticated) {
        return _retryAuthenticated(
          (newHeaders) => http.delete(uri, headers: newHeaders),
        );
      }

      return processed;
    } catch (e) {
      return {
        'error': true,
        'statusCode': 0,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}
