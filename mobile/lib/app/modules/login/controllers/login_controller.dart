import 'package:get/get.dart';
import 'package:mobile/app/data/auth_api.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  final AuthApi _authApi = AuthApi();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Email dan password harus diisi');
      return;
    }

    isLoading.value = true;
    try {
      final result = await _authApi.login(
        email: email.value.trim(),
        password: password.value,
      );

      if (result['error'] == true) {
        Get.snackbar(
          'Login Gagal',
          result['message'] ?? 'Email atau password salah',
        );
        return;
      }

      Get.offAllNamed(Routes.HOME);
    } finally {
      isLoading.value = false;
    }
  }
}
