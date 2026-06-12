import 'package:get/get.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../controllers/calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleRepository>(() => ScheduleRepository());
    Get.lazyPut<CalendarController>(
      () => CalendarController(scheduleRepository: Get.find()),
    );
  }
}
