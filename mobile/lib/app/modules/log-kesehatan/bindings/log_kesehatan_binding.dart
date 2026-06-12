import 'package:get/get.dart';
import '../../../data/repositories/health_repository.dart';
import '../controllers/log_kesehatan_controller.dart';

class LogKesehatanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthRepository>(() => HealthRepository());
    Get.lazyPut<LogKesehatanController>(
      () => LogKesehatanController(healthRepository: Get.find()),
    );
  }
}
