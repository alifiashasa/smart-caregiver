import 'package:get/get.dart';
import '../controllers/jadwal_lansia_controller.dart';

class JadwalLansiaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JadwalLansiaController>(
      () => JadwalLansiaController(scheduleRepository: Get.find()),
    );
  }
}
