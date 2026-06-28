import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/calendar/controllers/calendar_controller.dart';

void main() {
  late CalendarController controller;

  setUp(() {
    Get.testMode = true;
    controller = CalendarController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should start at index 1', () {
      expect(controller.currentIndex.value, 1);
    });

    test('should have default patient data', () {
      expect(controller.patientName.value, 'Ibu Siti');
      expect(controller.patientAge.value, '55 Tahun');
      expect(controller.patientGender.value, 'Perempuan');
    });

    test('should have 3 mock schedules', () {
      expect(controller.mockSchedules.length, 3);
    });

    test('schedules should have correct structure', () {
      final firstSchedule = controller.mockSchedules[0];
      expect(firstSchedule['id'], '1');
      expect(firstSchedule['title'], 'Minum Obat Aspirin');
      expect(firstSchedule['schedule_type'], 'medication');
      expect(firstSchedule['scheduled_at'], isA<DateTime>());
      expect(firstSchedule['is_completed'], false);
    });

    test('some schedules should be completed', () {
      final thirdSchedule = controller.mockSchedules[2];
      expect(thirdSchedule['id'], '3');
      expect(thirdSchedule['is_completed'], true);
    });
  });

  group('toggleScheduleCompletion', () {
    test('should toggle schedule from incomplete to complete', () {
      controller.toggleScheduleCompletion('1');
      final schedule = controller.mockSchedules.firstWhere((s) => s['id'] == '1');
      expect(schedule['is_completed'], true);
    });

    test('should toggle schedule from complete to incomplete', () {
      controller.toggleScheduleCompletion('3');
      final schedule = controller.mockSchedules.firstWhere((s) => s['id'] == '3');
      expect(schedule['is_completed'], false);
    });

    test('should toggle back and forth', () {
      controller.toggleScheduleCompletion('2'); // false -> true
      controller.toggleScheduleCompletion('2'); // true -> false
      final schedule = controller.mockSchedules.firstWhere((s) => s['id'] == '2');
      expect(schedule['is_completed'], false);
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

      // Find by title since sorting may change position
      final added = controller.mockSchedules.firstWhere((s) => s['title'] == 'Test Schedule');
      expect(added['id'], isNotEmpty);
      expect(added['id'], isNot('1')); // Should be auto-generated
      expect(added['is_completed'], false);
    });

    test('should sort schedules by scheduled_at', () {
      // Add a schedule far in the future
      final futureDate = DateTime.now().add(const Duration(days: 30));
      controller.addSchedule({
        'title': 'Future Schedule',
        'schedule_type': 'medication',
        'scheduled_at': futureDate,
        'duration_minutes': 15,
      });

      // Future schedule should be at the end after sorting
      expect(controller.mockSchedules.last['title'], 'Future Schedule');
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

      final earlyIdx = controller.mockSchedules.indexWhere((s) => s['title'] == 'Early');
      final lateIdx = controller.mockSchedules.indexWhere((s) => s['title'] == 'Late');
      expect(earlyIdx, lessThan(lateIdx));
    });
  });

  group('changePage', () {
    test('should not navigate to same page', () {
      controller.currentIndex.value = 1;
      controller.changePage(1);
      expect(controller.currentIndex.value, 1);
    });

    test('should update index when navigating', () {
      controller.changePage(0);
      expect(controller.currentIndex.value, 0);
    });
  });
}
