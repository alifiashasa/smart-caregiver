import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        dashboardRepository: Get.find(),
        notificationRepository: Get.find(),
      ),
    );
  }
}
