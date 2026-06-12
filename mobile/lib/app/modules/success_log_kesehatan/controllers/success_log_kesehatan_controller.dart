import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SuccessLogKesehatanController extends GetxController {
  // ── Reactive state ──
  final _healthStatus = 'Normal'.obs;
  final _healthMessage = 'Data kesehatan berhasil dicatat.'.obs;
  final _fuzzyCardioScore = 0.0.obs;
  final _fuzzyMetabolicScore = 0.0.obs;
  final _fuzzyInfectionScore = 0.0.obs;

  // Patient info for navigating back to dashboard
  String? _elderlyId;
  String? _patientName;

  // ── Public getters ──
  String get healthStatus => _healthStatus.value;
  String get healthMessage => _healthMessage.value;
  double get fuzzyCardioScore => _fuzzyCardioScore.value;
  double get fuzzyMetabolicScore => _fuzzyMetabolicScore.value;
  double get fuzzyInfectionScore => _fuzzyInfectionScore.value;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      _healthStatus.value = args['status'] as String? ?? 'Normal';
      _healthMessage.value =
          args['message'] as String? ?? 'Data kesehatan berhasil dicatat.';
      _fuzzyCardioScore.value = _readScore(args['cardio_score']);
      _fuzzyMetabolicScore.value = _readScore(args['metabolic_score']);
      _fuzzyInfectionScore.value = _readScore(args['infection_score']);
      _elderlyId = args['elderly_id']?.toString();
      _patientName = args['name'] as String?;
    }
  }

  /// Navigate back to dashboard, triggering a fresh data load.
  void goToDashboard() {
    if (_elderlyId == null || _elderlyId!.isEmpty) {
      Get.offAllNamed(Routes.HOME);
      return;
    }
    Get.offAllNamed(
      Routes.DASHBOARD,
      arguments: {
        'from': 0,
        'elderly_id': _elderlyId,
        'name': _patientName ?? '',
      },
    );
  }

  double _readScore(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
