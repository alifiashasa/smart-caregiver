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

  Future<void> register() async {
    if (name.value.isEmpty || email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi');
      return;
    }
    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Password tidak cocok');
      return;
    }
    if (password.value.length < 8) {
      Get.snackbar('Error', 'Password minimal 8 karakter');
      return;
    }

    isLoading.value = true;
    try {
      final result = await _authApi.register(
        email: email.value.trim(),
        password: password.value,
        fullName: name.value.trim(),
      );

      if (result['error'] == true) {
        Get.snackbar(
          'Registrasi Gagal',
          result['message'] ?? 'Terjadi kesalahan',
        );
        return;
      }

      // Registration successful — show OTP input
      registeredEmail.value = email.value.trim();
      final data = result['data'] as Map<String, dynamic>?;
      if (data != null && data['otp_expires_in_minutes'] != null) {
        otpExpiresMinutes.value = data['otp_expires_in_minutes'] as int;
      }
      showOtpField.value = true;
      Get.snackbar(
        'Kode OTP Dikirim',
        'Cek email ${email.value.trim()} untuk kode verifikasi',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otp.value.length != 6) {
      Get.snackbar('Error', 'Kode OTP harus 6 digit');
      return;
    }

    isLoading.value = true;
    try {
      final result = await _authApi.verifyOtp(
        email: registeredEmail.value,
        otp: otp.value,
      );

      if (result['error'] == true) {
        Get.snackbar(
          'Verifikasi Gagal',
          result['message'] ?? 'Kode OTP salah atau kadaluarsa',
        );
        return;
      }

      Get.snackbar('Berhasil', 'Akun berhasil diaktifkan. Silakan masuk.');
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }
}
