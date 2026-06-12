import 'package:get/get.dart';
import '../../../data/repositories/elderly_repository.dart';
import '../../../data/repositories/health_repository.dart';
import '../controllers/patient_detail_controller.dart';

class PatientDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ElderlyRepository>(() => ElderlyRepository());
    Get.lazyPut<HealthRepository>(() => HealthRepository());
    Get.lazyPut<PatientDetailController>(
      () => PatientDetailController(
        elderlyRepository: Get.find(),
        healthRepository: Get.find(),
      ),
    );
  }
}
