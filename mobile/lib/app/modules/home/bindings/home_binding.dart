import 'package:get/get.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(() => DashboardRepository(), fenix: true);
    Get.lazyPut<NotificationRepository>(() => NotificationRepository());
    Get.lazyPut<HomeController>(
      () => HomeController(
        dashboardRepository: Get.find(),
        notificationRepository: Get.find(),
      ),
    );
  }
}
