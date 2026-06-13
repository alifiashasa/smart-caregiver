import 'package:get/get.dart';
import 'package:mobile/app/data/api_client.dart';
import 'package:mobile/app/data/repositories/auth_repository.dart';
import 'package:mobile/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository;

  SplashController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  Future<void> start() async {
    if (_isLoading.value) return;

    _isLoading.value = true;
    try {
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
      ApiClient.clearTokens();
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      _isLoading.value = false;
    }
  }
}
