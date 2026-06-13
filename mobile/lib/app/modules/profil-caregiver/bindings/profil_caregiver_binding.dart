import 'package:get/get.dart';
import '../controllers/profil_caregiver_controller.dart';

class ProfilCaregiverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilCaregiverController>(
      () => ProfilCaregiverController(authRepository: Get.find()),
    );
  }
}
