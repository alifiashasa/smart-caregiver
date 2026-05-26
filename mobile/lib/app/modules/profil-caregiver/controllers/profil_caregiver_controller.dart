import 'package:get/get.dart';
import 'package:mobile/app/data/auth_api.dart';
import '../../../routes/app_pages.dart';

class ProfilCaregiverController extends GetxController {
  final count = 0.obs;
  final fullName = ''.obs;
  final email = ''.obs;

  final AuthApi _authApi = AuthApi();

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final result = await _authApi.getMe();
    if (result['error'] == false) {
      final data = result['data'] as Map<String, dynamic>;
      fullName.value = data['full_name'] ?? '';
      email.value = data['email'] ?? '';
    }
  }

  void increment() => count.value++;

  void logout() {
    _authApi.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
