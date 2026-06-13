import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl {
    // 1. Compile-time --dart-define for staging/production builds.
    const dartDefineUrl = String.fromEnvironment('API_BASE_URL');
    if (dartDefineUrl.isNotEmpty) return dartDefineUrl;

    // 2. Runtime .env file for local development.
    final envUrl = dotenv.maybeGet('API_BASE_URL');
    if (envUrl != null && envUrl.isNotEmpty) return envUrl;

    // 3. Platform-specific fallback
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }

    return 'http://localhost:8000';
  }

  static const Duration requestTimeout = Duration(seconds: 30);
}
