import 'package:get/get.dart';
import '../controllers/template_jadwal_controller.dart';

class TemplateJadwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TemplateJadwalController>(
      () => TemplateJadwalController(scheduleRepository: Get.find()),
    );
  }
}
