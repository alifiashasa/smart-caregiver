import 'package:get/get.dart';
import '../../../data/models/health_log_result_args.dart';
import '../../../data/models/patient_route_args.dart';
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
      final args = HealthLogResultArgs.fromMap(Get.arguments as Map);
      _healthStatus.value = args.status;
      _healthMessage.value = args.message;
      _fuzzyCardioScore.value = args.cardioScore;
      _fuzzyMetabolicScore.value = args.metabolicScore;
      _fuzzyInfectionScore.value = args.infectionScore;
      _elderlyId = args.elderlyId;
      _patientName = args.patientName;
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
      arguments: PatientRouteArgs(
        elderlyId: _elderlyId!,
        name: _patientName ?? '',
        age: '',
        gender: '',
        image: PatientRouteArgs.defaultImage,
      ).toMap(),
    );
  }
}
