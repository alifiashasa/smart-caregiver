import '../../core/api_result.dart';
import '../api_client.dart';
import '../auth_api.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthApi _authApi;
  AuthRepository() : _authApi = AuthApi();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) => _authApi.login(email: email, password: password);

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
  }) => _authApi.register(email: email, password: password, fullName: fullName);

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) => _authApi.verifyOtp(email: email, otp: otp);

  Future<Map<String, dynamic>> getMe() => _authApi.getMe();

  Future<ApiResult<UserModel>> getCurrentUser() async {
    final response = await _authApi.getMe();
    final result = response.toApiResult();

    return result.when(
      success: (data) => ApiResult.success(UserModel.fromJson(data)),
      failure: (failure) => ApiResult.failure(
        failure.message,
        statusCode: failure.statusCode,
        sessionExpired: failure.sessionExpired,
        detailBody: failure.detailBody,
      ),
    );
  }

  Future<ApiResult<UserModel>> updateProfile({
    String? fullName,
    String? phone,
  }) async {
    final response = await _authApi.updateProfile(
      fullName: fullName,
      phone: phone,
    );
    final result = response.toApiResult();

    return result.when(
      success: (data) => ApiResult.success(UserModel.fromJson(data)),
      failure: (failure) => ApiResult.failure(
        failure.message,
        statusCode: failure.statusCode,
        sessionExpired: failure.sessionExpired,
        detailBody: failure.detailBody,
      ),
    );
  }

  Future<Map<String, dynamic>> refreshToken() => _authApi.refreshToken();

  bool get isLoggedIn => ApiClient.getAccessToken() != null;

  void logout() => _authApi.logout();
}
