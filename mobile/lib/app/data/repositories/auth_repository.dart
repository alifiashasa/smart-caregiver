import 'dart:typed_data';
import '../../core/api_result.dart';
import '../api_client.dart';
import '../auth_api.dart';
import '../auth_face_api.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthApi _authApi;
  final AuthFaceApi _faceApi;

  AuthRepository() : _authApi = AuthApi(), _faceApi = AuthFaceApi();

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

  Future<Map<String, dynamic>> refreshToken() => _authApi.refreshToken();

  Future<Map<String, dynamic>> faceStatus() => _faceApi.faceStatus();

  Future<Map<String, dynamic>> registerFace({required Uint8List imageBytes}) =>
      _faceApi.registerFace(imageBytes: imageBytes);

  Future<Map<String, dynamic>> verifyFace({required Uint8List imageBytes}) =>
      _faceApi.verifyFace(imageBytes: imageBytes);

  bool get isLoggedIn => ApiClient.getAccessToken() != null;

  void logout() => _authApi.logout();
}
