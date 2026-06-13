import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../core/config.dart';
import '../core/logger.dart';

class ApiClient {
  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: AppConfig.requestTimeout,
          receiveTimeout: AppConfig.requestTimeout,
          sendTimeout: AppConfig.requestTimeout,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
          validateStatus: (_) => true,
        ),
      ) {
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          final authenticated = options.extra['authenticated'] == true;
          final token = getAccessToken();
          if (authenticated && token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          compact: true,
        ),
      );
    }
  }

  static final GetStorage _storage = GetStorage();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final Dio _dio;

  static String? _accessToken;
  static String? _refreshToken;
  static Future<bool>? _refreshFuture;

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

  Options _options({bool authenticated = false}) {
    return Options(extra: {'authenticated': authenticated});
  }

  Map<String, dynamic> _readBody(Response<dynamic> response) {
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data == null || data == '') return <String, dynamic>{};
    return {'data': data};
  }

  /// Attempt to refresh the JWT token.
  /// Returns true if refresh succeeded and tokens were updated.
  Future<bool> _tryRefreshToken() {
    final pendingRefresh = _refreshFuture;
    if (pendingRefresh != null) return pendingRefresh;

    final refresh = _performRefreshToken().whenComplete(() {
      _refreshFuture = null;
    });
    _refreshFuture = refresh;
    return refresh;
  }

  Future<bool> _performRefreshToken() async {
    try {
      final currentRefreshToken = getRefreshToken();
      if (currentRefreshToken == null) return false;

      final response = await _dio.post<dynamic>(
        '/auth/refresh',
        data: {'refresh_token': currentRefreshToken},
      );

      if (response.statusCode == 200) {
        final body = _readBody(response);
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
    }
  }

  Future<Map<String, dynamic>> _processResponse(
    Response<dynamic> response, {
    bool retried = false,
  }) async {
    final statusCode = response.statusCode ?? 0;
    final body = _readBody(response);

    if (statusCode == 401 && !retried) {
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

    if (statusCode >= 400) {
      final message = body['detail'] ?? body['message'] ?? 'Permintaan gagal';
      log.api(
        '?',
        response.requestOptions.uri.toString(),
        statusCode,
        response: body,
      );
      return {
        'error': true,
        'statusCode': statusCode,
        'message': message,
        'detail_body': body, // keep raw body for rich error display
      };
    }

    return {'error': false, 'statusCode': statusCode, 'data': body};
  }

  /// Retry a request after token refresh by rebuilding headers.
  Future<Map<String, dynamic>> _retryAuthenticated(
    Future<Response<dynamic>> Function() request,
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

    try {
      final response = await request();
      return _processResponse(response, retried: true);
    } catch (e) {
      return {
        'error': true,
        'statusCode': 0,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Map<String, dynamic> _networkError(Object error) {
    return {
      'error': true,
      'statusCode': 0,
      'message': 'Network error: ${error.toString()}',
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
      log.api('GET', endpoint, null);
      final response = await _dio.get<dynamic>(
        endpoint,
        options: _options(authenticated: authenticated),
      );

      final processed = await _processResponse(response);
      log.api('GET', endpoint, response.statusCode);

      // If token was refreshed, retry the original request
      if (processed['statusCode'] == 498 && authenticated) {
        return _retryAuthenticated(
          () => _dio.get<dynamic>(
            endpoint,
            options: _options(authenticated: true),
          ),
        );
      }

      return processed;
    } catch (e) {
      return _networkError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    try {
      log.api('POST', endpoint, null, request: body);
      final response = await _dio.post<dynamic>(
        endpoint,
        data: body,
        options: _options(authenticated: authenticated),
      );

      final processed = await _processResponse(response);
      log.api('POST', endpoint, response.statusCode);

      if (processed['statusCode'] == 498 && authenticated) {
        return _retryAuthenticated(
          () => _dio.post<dynamic>(
            endpoint,
            data: body,
            options: _options(authenticated: true),
          ),
        );
      }

      return processed;
    } catch (e) {
      return _networkError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    try {
      log.api('PUT', endpoint, null, request: body);
      final response = await _dio.put<dynamic>(
        endpoint,
        data: body,
        options: _options(authenticated: authenticated),
      );

      final processed = await _processResponse(response);
      log.api('PUT', endpoint, response.statusCode);

      if (processed['statusCode'] == 498 && authenticated) {
        return _retryAuthenticated(
          () => _dio.put<dynamic>(
            endpoint,
            data: body,
            options: _options(authenticated: true),
          ),
        );
      }

      return processed;
    } catch (e) {
      return _networkError(e);
    }
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    try {
      log.api('PATCH', endpoint, null, request: body);
      final response = await _dio.patch<dynamic>(
        endpoint,
        data: body,
        options: _options(authenticated: authenticated),
      );

      final processed = await _processResponse(response);
      log.api('PATCH', endpoint, response.statusCode);

      if (processed['statusCode'] == 498 && authenticated) {
        return _retryAuthenticated(
          () => _dio.patch<dynamic>(
            endpoint,
            data: body,
            options: _options(authenticated: true),
          ),
        );
      }

      return processed;
    } catch (e) {
      return _networkError(e);
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool authenticated = true,
  }) async {
    try {
      log.api('DELETE', endpoint, null);
      final response = await _dio.delete<dynamic>(
        endpoint,
        options: _options(authenticated: authenticated),
      );

      final processed = await _processResponse(response);
      log.api('DELETE', endpoint, response.statusCode);

      if (processed['statusCode'] == 498 && authenticated) {
        return _retryAuthenticated(
          () => _dio.delete<dynamic>(
            endpoint,
            options: _options(authenticated: true),
          ),
        );
      }

      return processed;
    } catch (e) {
      return _networkError(e);
    }
  }
}
