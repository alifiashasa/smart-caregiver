// ignore_for_file: constant_identifier_names
import 'package:get/get.dart';
import '../controllers/face_verify_controller.dart';

class FaceVerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceVerifyController>(
      () => FaceVerifyController(),
    );
  }
}
