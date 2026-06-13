import 'api_client.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

class AuthApi {
  final ApiClient _client = ApiClient();

  // ---------------------------------------------------------------------------
  // Registration & OTP verification
  // ---------------------------------------------------------------------------

  /// POST /auth/register
  /// Returns {message, email, otp_expires_in_minutes} on success.
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _client.post(
      '/auth/register',
      body: {'email': email, 'password': password, 'full_name': fullName},
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

  /// POST /auth/verify-otp
  /// Returns {message: "Email verified. Account is active."} on success.
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _client.post(
      '/auth/verify-otp',
      body: {'email': email, 'otp': otp},
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

  // ---------------------------------------------------------------------------
  // Authentication
  // ---------------------------------------------------------------------------

  /// POST /auth/login/json
  /// On success saves the access & refresh tokens and returns the response data.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      '/auth/login/json',
      body: {'email': email, 'password': password},
    );

    if (response['error'] == true) {
      return response;
    }

    final data = response['data'] as Map<String, dynamic>;
    final accessToken = data['access_token'] as String?;
    final refreshToken = data['refresh_token'] as String?;

    if (accessToken != null && refreshToken != null) {
      await ApiClient.saveTokens(accessToken, refreshToken);
    }

    return {'error': false, 'statusCode': response['statusCode'], 'data': data};
  }

  /// GET /auth/me — requires authentication.
  Future<Map<String, dynamic>> getMe() async {
    final response = await _client.get('/auth/me', authenticated: true);

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// POST /auth/refresh — saves the new tokens on success.
  Future<Map<String, dynamic>> refreshToken() async {
    final currentRefreshToken = ApiClient.getRefreshToken();

    if (currentRefreshToken == null) {
      return {
        'error': true,
        'statusCode': 401,
        'message': 'No refresh token available',
      };
    }

    final response = await _client.post(
      '/auth/refresh',
      body: {'refresh_token': currentRefreshToken},
    );

    if (response['error'] == true) {
      return response;
    }

    final data = response['data'] as Map<String, dynamic>;
    final newAccessToken = data['access_token'] as String?;
    final newRefreshToken = data['refresh_token'] as String?;

    if (newAccessToken != null && newRefreshToken != null) {
      await ApiClient.saveTokens(newAccessToken, newRefreshToken);
    }

    return {'error': false, 'statusCode': response['statusCode'], 'data': data};
  }

  /// Clears all stored data (client-side logout) and navigates to login.
  void logout() {
    ApiClient.clearAllStorage();
    // Navigate to login — must be called from a Get context
    Get.offAllNamed(Routes.LOGIN);
  }
}
