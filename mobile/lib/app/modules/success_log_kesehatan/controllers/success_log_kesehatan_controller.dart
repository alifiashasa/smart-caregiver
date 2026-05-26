import 'package:get/get.dart';

class SuccessLogKesehatanController extends GetxController {
  final healthStatus = ''.obs;
  final healthMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      healthStatus.value = args['status'] as String? ?? 'Normal';
      healthMessage.value =
          args['message'] as String? ?? 'Data kesehatan berhasil dicatat.';
    }
  }
}
