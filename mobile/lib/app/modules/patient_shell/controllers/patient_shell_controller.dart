import 'package:get/get.dart';
import '../../../data/models/patient_route_args.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../calendar/controllers/calendar_controller.dart';
import '../../patient_detail/controllers/patient_detail_controller.dart';
import '../../profil-lansia/controllers/profil_lansia_controller.dart';

class PatientShellController extends GetxController {
  final _currentIndex = 0.obs;
  bool _hasAppliedInitialTab = false;

  /// Shared patient data (reactive so tabs can observe if needed)
  final elderlyId = Rx<String>('');
  final patientName = Rx<String>('');
  final patientAge = Rx<String>('');
  final patientGender = Rx<String>('');
  final patientImage = Rx<String>(PatientRouteArgs.defaultImage);

  int get currentIndex => _currentIndex.value;

  void updatePatientProfile({
    String? name,
    String? age,
    String? gender,
    String? image,
  }) {
    if (name != null) patientName.value = name;
    if (age != null) patientAge.value = age;
    if (gender != null) patientGender.value = gender;
    if (image != null) patientImage.value = image;
  }

  void applyInitialTab(int index) {
    if (_hasAppliedInitialTab) return;
    _hasAppliedInitialTab = true;
    _currentIndex.value = index;
  }

  void changeTab(int index) {
    if (_currentIndex.value == index) return;
    _currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      final args = PatientRouteArgs.fromMap(Get.arguments as Map);
      elderlyId.value = args.elderlyId;
      patientName.value = args.name;
      patientAge.value = args.age;
      patientGender.value = args.gender;
      patientImage.value = args.image;
    }
  }

  @override
  void onClose() {
    Get.delete<DashboardController>();
    Get.delete<CalendarController>();
    Get.delete<PatientDetailController>();
    Get.delete<ProfilLansiaController>();
    super.onClose();
  }
}
