import 'package:get/get.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../calendar/controllers/calendar_controller.dart';
import '../../patient_detail/controllers/patient_detail_controller.dart';
import '../../profil-lansia/controllers/profil_lansia_controller.dart';
import '../controllers/patient_shell_controller.dart';

class PatientShellBinding extends Bindings {
  @override
  void dependencies() {
    // ── Shell controller first (tab controllers depend on it) ──
    Get.put(PatientShellController());

    // ── Tab controllers (recreated each time shell opens) ──
    Get.put(DashboardController(dashboardRepository: Get.find()));
    Get.put(CalendarController(scheduleRepository: Get.find()));
    Get.put(
      PatientDetailController(
        elderlyRepository: Get.find(),
        healthRepository: Get.find(),
      ),
    );
    Get.put(ProfilLansiaController(elderlyRepository: Get.find()));
  }
}
