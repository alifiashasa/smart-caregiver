import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/calendar/controllers/calendar_controller.dart';
import 'package:mobile/app/modules/patient_shell/controllers/patient_shell_controller.dart';
import '../test_helpers.dart';

void main() {
  late CalendarController controller;
  late MockScheduleRepository mockScheduleRepository;

  setUp(() {
    mockScheduleRepository = MockScheduleRepository();
    stubCalendarControllerDeps(mockScheduleRepository);
    Get.testMode = true;
    final shell = PatientShellController();
    shell.patientGender.value = 'Perempuan';
    Get.put(shell);
    controller = CalendarController(scheduleRepository: mockScheduleRepository);
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should have default patient data', () {
      expect(controller.patientName, '');
      expect(controller.patientAge, '');
      expect(controller.patientGender, 'Perempuan');
    });

    test('should start with empty schedules', () {
      expect(controller.schedules.length, 0);
    });

    test('should have isLoading false by default', () {
      expect(controller.isLoading, false);
    });
  });

  group('addSchedule', () {
    test('should add schedule with generated id and default is_completed', () {
      final now = DateTime.now();
      controller.addSchedule({
        'title': 'Test Schedule',
        'schedule_type': 'daily_activity',
        'scheduled_at': now,
        'duration_minutes': 30,
      });

      expect(controller.schedules.length, 1);
      final added = controller.schedules.first;
      expect(added.id, isNotEmpty);
      expect(added.title, 'Test Schedule');
      expect(added.isCompleted, false);
    });

    test('should sort schedules by scheduled_at', () {
      final now = DateTime.now();
      // Add a schedule far in the future
      final futureDate = now.add(const Duration(days: 30));
      controller.addSchedule({
        'id': 'future-schedule',
        'title': 'Future Schedule',
        'schedule_type': 'medication',
        'scheduled_at': futureDate,
        'duration_minutes': 15,
      });

      // Add current schedule
      controller.addSchedule({
        'id': 'current-schedule',
        'title': 'Current Schedule',
        'schedule_type': 'daily_activity',
        'scheduled_at': now,
        'duration_minutes': 30,
      });

      expect(controller.schedules.length, 2);
      // Ascending sort by scheduledAt: earliest first
      expect(controller.schedules.first.scheduledAt
          .isBefore(controller.schedules.last.scheduledAt), isTrue);
    });

    test('should add multiple schedules and maintain order', () {
      final now = DateTime.now();
      final earlier = now.subtract(const Duration(hours: 2));
      final later = now.add(const Duration(hours: 2));

      controller.addSchedule({
        'title': 'Early',
        'scheduled_at': earlier,
      });
      controller.addSchedule({
        'title': 'Late',
        'scheduled_at': later,
      });

      final earlyIdx = controller.schedules.indexWhere((s) => s.title == 'Early');
      final lateIdx = controller.schedules.indexWhere((s) => s.title == 'Late');
      expect(earlyIdx, lessThan(lateIdx));
    });
  });

  group('selectDate', () {
    test('should select a date and update selectedDate', () {
      final date = DateTime(2026, 12, 25);
      controller.selectDate(date);
      expect(controller.selectedDate, DateTime(2026, 12, 25));
    });

    test('isSelectedDate should return true for selected date', () {
      final date = DateTime(2026, 12, 25);
      controller.selectDate(date);
      expect(controller.isSelectedDate(date), true);
    });
  });
}
