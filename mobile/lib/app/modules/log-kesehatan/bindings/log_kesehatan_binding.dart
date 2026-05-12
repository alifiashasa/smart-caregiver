import 'package:get/get.dart';

import '../controllers/log_kesehatan_controller.dart';

class LogKesehatanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogKesehatanController>(() => LogKesehatanController());
  }
}
