import 'package:get/get.dart';
import 'package:mobile/app/data/api_client.dart';
import 'package:mobile/app/data/auth_api.dart';
import 'package:mobile/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthApi _authApi = AuthApi();

  @override
  void onReady() {
    super.onReady();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Brief delay to show splash
    await Future.delayed(const Duration(milliseconds: 1500));

    final token = ApiClient.getAccessToken();
    if (token == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    // Validate token by calling /auth/me
    final result = await _authApi.getMe();

    if (result['error'] == false) {
      // Token valid — user is authenticated
      Get.offAllNamed(Routes.HOME);
    } else {
      // Token expired or invalid — try refresh
      final refreshResult = await _authApi.refreshToken();
      if (refreshResult['error'] == false) {
        Get.offAllNamed(Routes.HOME);
      } else {
        ApiClient.clearTokens();
        Get.offAllNamed(Routes.LOGIN);
      }
    }
  }
}
