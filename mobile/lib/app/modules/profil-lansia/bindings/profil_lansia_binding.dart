import 'package:get/get.dart';

import '../controllers/profil_lansia_controller.dart';

class ProfilLansiaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilLansiaController>(() => ProfilLansiaController());
  }
}
