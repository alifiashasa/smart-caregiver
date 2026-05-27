import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/data/auth_api.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;

  // OTP state
  final showOtpField = false.obs;
  final otp = ''.obs;
  final registeredEmail = ''.obs;
  final otpExpiresMinutes = 5.obs;

  final AuthApi _authApi = AuthApi();

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  bool _validate() {
    if (name.value.trim().isEmpty) {
      _showError('Nama lengkap harus diisi');
      return false;
    }
    if (email.value.trim().isEmpty) {
      _showError('Email harus diisi');
      return false;
    }
    if (!GetUtils.isEmail(email.value.trim())) {
      _showError('Format email tidak valid');
      return false;
    }
    if (password.value.isEmpty) {
      _showError('Password harus diisi');
      return false;
    }
    if (password.value.length < 6) {
      _showError('Password minimal 6 karakter');
      return false;
    }
    if (password.value != confirmPassword.value) {
      _showError('Password dan konfirmasi password tidak sama');
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

  Future<void> register() async {
    if (!_validate()) return;

    isLoading.value = true;

    final result = await _authApi.register(
      email: email.value.trim(),
      password: password.value,
      fullName: name.value.trim(),
    );

    isLoading.value = false;

    if (result['error'] == true) {
      Get.snackbar(
        'Gagal Daftar',
        result['message'] ?? 'Terjadi kesalahan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    // Registration success — show OTP verification
    registeredEmail.value = email.value.trim();
    showOtpField.value = true;
    Get.snackbar(
      'Berhasil Daftar',
      'Kode OTP telah dikirim ke ${email.value.trim()}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFBBF246),
      colorText: const Color(0xFF192126),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> verifyOtp() async {
    if (otp.value.trim().isEmpty) {
      _showError('Kode OTP harus diisi');
      return;
    }
    if (otp.value.trim().length < 4) {
      _showError('Kode OTP tidak valid');
      return;
    }

    isLoading.value = true;

    final result = await _authApi.verifyOtp(
      email: registeredEmail.value,
      otp: otp.value.trim(),
    );

    isLoading.value = false;

    if (result['error'] == true) {
      Get.snackbar(
        'Gagal Verifikasi',
        result['message'] ?? 'Kode OTP salah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    Get.snackbar(
      'Akun Aktif',
      'Silakan daftarkan wajah untuk verifikasi login',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFBBF246),
      colorText: const Color(0xFF192126),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );

    Get.offNamed(Routes.FACE_REGISTER);
  }
}