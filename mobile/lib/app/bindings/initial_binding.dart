import 'package:get/get.dart';

import '../data/repositories/ai_repository.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/dashboard_repository.dart';
import '../data/repositories/elderly_repository.dart';
import '../data/repositories/health_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/schedule_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<ElderlyRepository>(() => ElderlyRepository(), fenix: true);
    Get.lazyPut<HealthRepository>(() => HealthRepository(), fenix: true);
    Get.lazyPut<ScheduleRepository>(() => ScheduleRepository(), fenix: true);
    Get.lazyPut<DashboardRepository>(() => DashboardRepository(), fenix: true);
    Get.lazyPut<NotificationRepository>(
      () => NotificationRepository(),
      fenix: true,
    );
    Get.lazyPut<AiRepository>(() => AiRepository(), fenix: true);
  }
}
