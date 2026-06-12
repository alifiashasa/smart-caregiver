import 'package:get/get.dart';
import '../controllers/success_log_kesehatan_controller.dart';

class SuccessLogKesehatanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuccessLogKesehatanController>(
      () => SuccessLogKesehatanController(),
    );
  }
}
