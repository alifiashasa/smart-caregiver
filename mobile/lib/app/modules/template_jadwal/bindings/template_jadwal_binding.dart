import 'package:get/get.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../controllers/template_jadwal_controller.dart';

class TemplateJadwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleRepository>(() => ScheduleRepository());
    Get.lazyPut<TemplateJadwalController>(
      () => TemplateJadwalController(scheduleRepository: Get.find()),
    );
  }
}
