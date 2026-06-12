import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../controllers/profil_caregiver_controller.dart';

class ProfilCaregiverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<ProfilCaregiverController>(
      () => ProfilCaregiverController(authRepository: Get.find()),
    );
  }
}
