import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/data/repositories/auth_repository.dart';
import 'package:mobile/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepository;

  RegisterController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  // ── Reactive state ──
  final _name = ''.obs;
  final _email = ''.obs;
  final _password = ''.obs;
  final _confirmPassword = ''.obs;
  final _obscurePassword = true.obs;
  final _obscureConfirmPassword = true.obs;
  final _isLoading = false.obs;

  // OTP state
  final _showOtpField = false.obs;
  final _otp = ''.obs;
  final _registeredEmail = ''.obs;
  final _otpExpiresMinutes = 5.obs;

  // ── Public getters ──
  String get name => _name.value;
  String get email => _email.value;
  String get password => _password.value;
  String get confirmPassword => _confirmPassword.value;
  bool get obscurePassword => _obscurePassword.value;
  bool get obscureConfirmPassword => _obscureConfirmPassword.value;
  bool get isLoading => _isLoading.value;
  bool get showOtpField => _showOtpField.value;
  String get otp => _otp.value;
  String get registeredEmail => _registeredEmail.value;
  int get otpExpiresMinutes => _otpExpiresMinutes.value;

  set name(String value) => _name.value = value;
  set email(String value) => _email.value = value;
  set password(String value) => _password.value = value;
  set confirmPassword(String value) => _confirmPassword.value = value;
  set otp(String value) => _otp.value = value;
  set showOtpField(bool value) => _showOtpField.value = value;

  void togglePasswordVisibility() =>
      _obscurePassword.value = !_obscurePassword.value;

  void toggleConfirmPasswordVisibility() =>
      _obscureConfirmPassword.value = !_obscureConfirmPassword.value;

  bool _validate() {
    if (_name.value.trim().isEmpty) {
      _showError('Nama lengkap harus diisi');
      return false;
    }
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
    if (_password.value != _confirmPassword.value) {
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

    _isLoading.value = true;

    final result = await _authRepository.register(
      email: _email.value.trim(),
      password: _password.value,
      fullName: _name.value.trim(),
    );

    _isLoading.value = false;

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

    _registeredEmail.value = _email.value.trim();
    _showOtpField.value = true;
    Get.snackbar(
      'Berhasil Daftar',
      'Kode OTP telah dikirim ke ${_email.value.trim()}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFBBF246),
      colorText: const Color(0xFF192126),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> verifyOtp() async {
    if (_otp.value.trim().isEmpty) {
      _showError('Kode OTP harus diisi');
      return;
    }
    if (_otp.value.trim().length < 4) {
      _showError('Kode OTP tidak valid');
      return;
    }

    _isLoading.value = true;

    final result = await _authRepository.verifyOtp(
      email: _registeredEmail.value,
      otp: _otp.value.trim(),
    );

    _isLoading.value = false;

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
