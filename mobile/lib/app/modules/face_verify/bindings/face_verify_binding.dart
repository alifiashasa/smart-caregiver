import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../controllers/face_verify_controller.dart';

class FaceVerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<FaceVerifyController>(
      () => FaceVerifyController(authRepository: Get.find()),
    );
  }
}
