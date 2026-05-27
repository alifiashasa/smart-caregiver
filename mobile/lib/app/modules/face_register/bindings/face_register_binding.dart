// ignore_for_file: constant_identifier_names
import 'package:get/get.dart';
import '../controllers/face_register_controller.dart';

class FaceRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceRegisterController>(
      () => FaceRegisterController(),
    );
  }
}
