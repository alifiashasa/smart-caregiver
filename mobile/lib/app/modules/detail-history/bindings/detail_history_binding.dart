import 'package:get/get.dart';
import '../../../data/repositories/health_repository.dart';
import '../controllers/detail_history_controller.dart';

class DetailHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthRepository>(() => HealthRepository());
    Get.lazyPut<DetailHistoryController>(
      () => DetailHistoryController(healthRepository: Get.find()),
    );
  }
}
