import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/data/auth_api.dart';
import 'package:mobile/app/data/auth_face_api.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  final AuthApi _authApi = AuthApi();
  final AuthFaceApi _faceApi = AuthFaceApi();

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
        email: email.value.trim().toLowerCase(),
        password: password.value.trim(),
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

      // Login succeeded — check if face is registered
      await _checkFaceStatusAndNavigate();
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

  Future<void> _checkFaceStatusAndNavigate() async {
    try {
      final statusResult = await _faceApi.faceStatus();
      final faceRegistered = statusResult['data']?['face_registered'] == true;
      if (faceRegistered) {
        isLoading.value = false;
        Get.offNamed(Routes.FACE_VERIFY);
      } else {
        isLoading.value = false;
        Get.offAllNamed(Routes.HOME);
      }
    } catch (_) {
      isLoading.value = false;
      // If face status check fails, still let user in
      Get.offAllNamed(Routes.HOME);
    }
  }
}
