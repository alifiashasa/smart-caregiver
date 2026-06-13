import 'package:get/get.dart';
import '../../../core/logger.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class ProfilCaregiverController extends GetxController {
  final AuthRepository _authRepository;

  ProfilCaregiverController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  // ── Reactive state ──
  final _fullName = ''.obs;
  final _email = ''.obs;

  // ── Public getters ──
  String get fullName => _fullName.value;
  String get email => _email.value;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final result = await _authRepository.getMe();
    if (result['error'] == false) {
      final data = result['data'] as Map<String, dynamic>;
      _fullName.value = data['full_name'] ?? '';
      _email.value = data['email'] ?? '';
      log.info(
        'Profile loaded',
        data: {'email': _email.value, 'full_name': _fullName.value},
      );
    } else {
      log.error(
        'Gagal load profil caregiver',
        data: {
          'message': result['message'],
          'statusCode': result['statusCode'],
        },
      );
    }
  }

  void logout() {
    _authRepository.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
