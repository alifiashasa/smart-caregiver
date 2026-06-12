import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/data/repositories/auth_repository.dart';
import 'package:mobile/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;

  LoginController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  // ── Reactive state ──
  final _email = ''.obs;
  final _password = ''.obs;
  final _isPasswordHidden = true.obs;
  final _isLoading = false.obs;

  // ── Public getters ──
  String get email => _email.value;
  String get password => _password.value;
  bool get isPasswordHidden => _isPasswordHidden.value;
  bool get isLoading => _isLoading.value;

  set email(String value) => _email.value = value;
  set password(String value) => _password.value = value;

  void togglePasswordVisibility() =>
      _isPasswordHidden.value = !_isPasswordHidden.value;

  bool _validate() {
    if (_email.value.trim().isEmpty) {
      _showError('Email harus diisi');
      return false;
    }
    if (!GetUtils.isEmail(_email.value.trim())) {
      _showError('Format email tidak valid');
      return false;
    }
    if (_password.value.isEmpty) {
      _showError('Password harus diisi');
      return false;
    }
    if (_password.value.length < 6) {
      _showError('Password minimal 6 karakter');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      'Validasi',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: const Color(0xFF192126),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> login() async {
    if (!_validate()) return;

    _isLoading.value = true;
    try {
      final result = await _authRepository.login(
        email: _email.value.trim().toLowerCase(),
        password: _password.value.trim(),
      );

      if (result['error'] == true) {
        _isLoading.value = false;
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

      await _checkFaceStatusAndNavigate();
    } catch (e) {
      _isLoading.value = false;
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
      final statusResult = await _authRepository.faceStatus();
      final faceRegistered =
          statusResult['data']?['face_registered'] == true;
      _isLoading.value = false;
      if (faceRegistered) {
        Get.offNamed(Routes.FACE_VERIFY);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (_) {
      _isLoading.value = false;
      Get.offAllNamed(Routes.HOME);
    }
  }
}
