import 'package:get/get.dart';
import '../../../data/repositories/ai_repository.dart';
import '../controllers/rekomendasi_ai_controller.dart';

class RekomendasiAiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiRepository>(() => AiRepository());
    Get.lazyPut<RekomendasiAiController>(
      () => RekomendasiAiController(aiRepository: Get.find()),
    );
  }
}
