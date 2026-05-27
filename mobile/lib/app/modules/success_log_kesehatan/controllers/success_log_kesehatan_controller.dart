import 'package:get/get.dart';

class SuccessLogKesehatanController extends GetxController {
  final healthStatus = 'Normal'.obs;
  final healthMessage = 'Data kesehatan berhasil dicatat.'.obs;
  final fuzzyCardioScore = 0.0.obs;
  final fuzzyMetabolicScore = 0.0.obs;
  final fuzzyInfectionScore = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      healthStatus.value = args['status'] as String? ?? 'Normal';
      healthMessage.value =
          args['message'] as String? ?? 'Data kesehatan berhasil dicatat.';
      fuzzyCardioScore.value = _readScore(args['cardio_score']);
      fuzzyMetabolicScore.value = _readScore(args['metabolic_score']);
      fuzzyInfectionScore.value = _readScore(args['infection_score']);
    }
  }

  double _readScore(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
