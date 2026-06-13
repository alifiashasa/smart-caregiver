import 'package:get/get.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../../../data/repositories/elderly_repository.dart';
import '../../../data/repositories/health_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../calendar/controllers/calendar_controller.dart';
import '../../patient_detail/controllers/patient_detail_controller.dart';
import '../../profil-lansia/controllers/profil_lansia_controller.dart';
import '../controllers/patient_shell_controller.dart';

class PatientShellBinding extends Bindings {
  @override
  void dependencies() {
    // ── Repositories (shared, stay alive across shell lifecycles) ──
    if (!Get.isRegistered<DashboardRepository>()) {
      Get.lazyPut<DashboardRepository>(() => DashboardRepository(),
          fenix: true);
    }
    if (!Get.isRegistered<ScheduleRepository>()) {
      Get.lazyPut<ScheduleRepository>(() => ScheduleRepository(), fenix: true);
    }
    if (!Get.isRegistered<ElderlyRepository>()) {
      Get.lazyPut<ElderlyRepository>(() => ElderlyRepository(), fenix: true);
    }
    if (!Get.isRegistered<HealthRepository>()) {
      Get.lazyPut<HealthRepository>(() => HealthRepository(), fenix: true);
    }
    if (!Get.isRegistered<NotificationRepository>()) {
      Get.lazyPut<NotificationRepository>(() => NotificationRepository(),
          fenix: true);
    }

    // ── Shell controller first (tab controllers depend on it) ──
    Get.put(PatientShellController());

    // ── Tab controllers (recreated each time shell opens) ──
    Get.put(DashboardController(dashboardRepository: Get.find()));
    Get.put(CalendarController(scheduleRepository: Get.find()));
    Get.put(PatientDetailController(
      elderlyRepository: Get.find(),
      healthRepository: Get.find(),
    ));
    Get.put(ProfilLansiaController(elderlyRepository: Get.find()));
  }
}
