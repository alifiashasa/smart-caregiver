import 'package:get/get.dart';
import '../../../data/repositories/elderly_repository.dart';
import '../controllers/tambah_lansia_controller.dart';

class TambahLansiaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ElderlyRepository>(() => ElderlyRepository());
    Get.lazyPut<TambahLansiaController>(
      () => TambahLansiaController(elderlyRepository: Get.find()),
    );
  }
}
