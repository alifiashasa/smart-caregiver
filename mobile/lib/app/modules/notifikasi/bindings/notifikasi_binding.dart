import 'package:get/get.dart';
import '../../../data/repositories/notification_repository.dart';
import '../controllers/notifikasi_controller.dart';

class NotifikasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationRepository>(() => NotificationRepository());
    Get.lazyPut<NotifikasiController>(
      () => NotifikasiController(notificationRepository: Get.find()),
    );
  }
}
