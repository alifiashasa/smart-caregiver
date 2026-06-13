import 'package:get/get.dart';
import '../controllers/rekomendasi_ai_controller.dart';

class RekomendasiAiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RekomendasiAiController>(
      () => RekomendasiAiController(aiRepository: Get.find()),
    );
  }
}
