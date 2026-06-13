import 'package:get/get.dart';
import 'package:mobile/app/core/ui/app_feedback.dart';
import 'package:mobile/app/core/validators/app_validators.dart';
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
    final emailError = AppValidators.email(_email.value);
    if (emailError != null) {
      _showError(emailError);
      return false;
    }

    final passwordError = AppValidators.minLength(
      _password.value,
      'Password',
      6,
    );
    if (passwordError != null) {
      _showError(passwordError);
      return false;
    }

    return true;
  }

  void _showError(String message) {
    AppFeedback.error('Validasi', message);
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
        AppFeedback.error(
          'Gagal Masuk',
          result['message'] ?? 'Email atau password salah',
        );
        return;
      }

      await _checkFaceStatusAndNavigate();
    } catch (e) {
      _isLoading.value = false;
      AppFeedback.error('Error', 'Terjadi kesalahan jaringan. Coba lagi.');
    }
  }

  Future<void> _checkFaceStatusAndNavigate() async {
    try {
      final statusResult = await _authRepository.faceStatus();
      final faceRegistered = statusResult['data']?['face_registered'] == true;
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
