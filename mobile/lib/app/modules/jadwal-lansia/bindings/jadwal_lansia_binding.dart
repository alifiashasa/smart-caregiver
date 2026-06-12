import 'package:get/get.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../controllers/jadwal_lansia_controller.dart';

class JadwalLansiaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleRepository>(() => ScheduleRepository());
    Get.lazyPut<JadwalLansiaController>(
      () => JadwalLansiaController(scheduleRepository: Get.find()),
    );
  }
}
