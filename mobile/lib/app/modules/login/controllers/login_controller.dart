import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/app/data/auth_api.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  final AuthApi _authApi = AuthApi();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  bool _validate() {
    if (email.value.trim().isEmpty) {
      Get.snackbar(
        'Validasi',
        'Email harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }
    if (!GetUtils.isEmail(email.value.trim())) {
      Get.snackbar(
        'Validasi',
        'Format email tidak valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }
    if (password.value.isEmpty) {
      Get.snackbar(
        'Validasi',
        'Password harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }
    if (password.value.length < 6) {
      Get.snackbar(
        'Validasi',
        'Password minimal 6 karakter',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }
    return true;
  }

  Future<void> login() async {
    if (!_validate()) return;

    isLoading.value = true;
    try {
      final result = await _authApi.login(
        email: email.value.trim(),
        password: password.value,
      );

      if (result['error'] == true) {
        isLoading.value = false;
        Get.snackbar(
          'Gagal Masuk',
          result['message'] ?? 'Email atau password salah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: const Color(0xFF192126),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan jaringan. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> loginWithGoogle() async {
    isGoogleLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isGoogleLoading.value = false;
        return; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.idToken == null) {
        isGoogleLoading.value = false;
        Get.snackbar(
          'Error',
          'Gagal mendapatkan token Google',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: const Color(0xFF192126),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }

      final result =
          await _authApi.loginWithGoogle(idToken: googleAuth.idToken!);

      if (result['error'] == true) {
        isGoogleLoading.value = false;
        Get.snackbar(
          'Gagal Masuk',
          result['message'] ?? 'Gagal login dengan Google',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: const Color(0xFF192126),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      isGoogleLoading.value = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}