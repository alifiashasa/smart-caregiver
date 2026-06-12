import 'package:get/get.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(() => DashboardRepository(), fenix: true);
    Get.lazyPut<DashboardController>(
      () => DashboardController(dashboardRepository: Get.find()),
      fenix: true,
    );
  }
}
