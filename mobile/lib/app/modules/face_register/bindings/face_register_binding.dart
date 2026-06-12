import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../controllers/face_register_controller.dart';

class FaceRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<FaceRegisterController>(
      () => FaceRegisterController(authRepository: Get.find()),
    );
  }
}
