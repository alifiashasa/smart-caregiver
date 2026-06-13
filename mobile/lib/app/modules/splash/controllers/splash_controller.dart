import 'package:get/get.dart';
import 'package:mobile/app/data/api_client.dart';
import 'package:mobile/app/data/repositories/auth_repository.dart';
import 'package:mobile/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository;

  SplashController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  void onReady() {
    super.onReady();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!_authRepository.isLoggedIn) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }
      final result = await _authRepository.getCurrentUser();
      result.when(
        success: (_) => Get.offAllNamed(Routes.HOME),
        failure: (_) async {
          final refreshResult = await _authRepository.refreshToken();
          if (refreshResult['error'] == false) {
            Get.offAllNamed(Routes.HOME);
          } else {
            ApiClient.clearTokens();
            Get.offAllNamed(Routes.LOGIN);
          }
        },
      );
    } catch (_) {
      // If anything unexpected fails, go to login
      ApiClient.clearTokens();
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
