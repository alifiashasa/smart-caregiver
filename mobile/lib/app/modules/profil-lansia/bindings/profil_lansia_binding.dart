import 'package:get/get.dart';
import '../../../data/repositories/elderly_repository.dart';
import '../controllers/profil_lansia_controller.dart';

class ProfilLansiaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ElderlyRepository>(() => ElderlyRepository());
    Get.lazyPut<ProfilLansiaController>(
      () => ProfilLansiaController(elderlyRepository: Get.find()),
    );
  }
}
