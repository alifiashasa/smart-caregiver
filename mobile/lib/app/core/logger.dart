// Simple structured logger for API debugging.

import 'package:flutter/foundation.dart';

/// Use [log] singleton throughout the app.
const log = _Logger();

class _Logger {
  const _Logger();

  void info(String message, {Map<String, dynamic>? data}) {
    if (!kReleaseMode) {
      _print('\x1B[36m[INFO]\x1B[0m', message, data);
    }
  }

  void warn(String message, {Map<String, dynamic>? data}) {
    if (!kReleaseMode) {
      _print('\x1B[33m[WARN]\x1B[0m', message, data);
    }
  }

  void error(String message, {Map<String, dynamic>? data, dynamic exception}) {
    if (!kReleaseMode) {
      _print('\x1B[31m[ERROR]\x1B[0m', message, data);
      if (exception != null) {
        debugPrint('  ╚═> Exception: $exception');
      }
    }
  }

  void api(String method, String endpoint, int? statusCode,
      {Map<String, dynamic>? request, Map<String, dynamic>? response}) {
    if (kReleaseMode) return;

    final icon = statusCode == null
        ? '➡️'
        : statusCode >= 400
            ? '❌'
            : '✅';
    debugPrint('━━━ $icon API $method $endpoint ━━━');
    if (statusCode != null) debugPrint('  Status: $statusCode');
    if (request != null && request.isNotEmpty) {
      debugPrint('  Request: $request');
    }
    if (response != null && response.isNotEmpty) {
      debugPrint('  Response: $response');
    }
  }

  void _print(String prefix, String message, Map<String, dynamic>? data) {
    debugPrint('$prefix $message');
    if (data != null && data.isNotEmpty) {
      debugPrint('  Data: $data');
    }
  }
}
