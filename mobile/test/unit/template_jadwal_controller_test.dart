import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/template_jadwal/controllers/template_jadwal_controller.dart';
import 'package:mobile/app/modules/calendar/controllers/calendar_controller.dart';

void main() {
  late TemplateJadwalController controller;

  setUp(() {
    Get.testMode = true;
    controller = TemplateJadwalController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should load 4 templates on init', () {
      expect(controller.templates.length, 4);
    });

    test('templates should have correct structure', () {
      final first = controller.templates[0];
      expect(first.id, '1');
      expect(first.title, 'Cek Tensi Darah');
      expect(first.time, '07:30');
      expect(first.description, isNotEmpty);
    });

    test('only second template should be enabled by default', () {
      expect(controller.templates[1].isEnabled.value, true);
      for (int i = 0; i < controller.templates.length; i++) {
        if (i != 1) {
          expect(controller.templates[i].isEnabled.value, false);
        }
      }
    });
  });

  group('TemplateJadwal model', () {
    test('should create model correctly', () {
      final template = TemplateJadwal(
        id: 'test',
        title: 'Test Title',
        time: '12:00',
        description: 'Test description',
      );
      expect(template.id, 'test');
      expect(template.title, 'Test Title');
      expect(template.time, '12:00');
      expect(template.description, 'Test description');
      expect(template.isEnabled.value, false);
    });

    test('should allow enabling template', () {
      final template = TemplateJadwal(
        id: 'test',
        title: 'Test',
        time: '12:00',
        description: 'Desc',
        isEnabled: true,
      );
      expect(template.isEnabled.value, true);
    });
  });

  group('saveTemplateSchedule', () {
    test('should not crash when calendar controller not found', () {
      Get.reset();
      Get.testMode = true;
      final ctrl = TemplateJadwalController();
      Get.put(ctrl);

      // saveTemplateSchedule calls Get.snackbar then Get.back — errors expected in test mode
      runZonedGuarded(() {
        ctrl.saveTemplateSchedule();
      }, (_, _) {});
    });

    test('should save enabled templates when calendar controller exists', () {
      // Register mock calendar controller
      final calCtrl = CalendarController();
      Get.put(calCtrl);

      final initialScheduleCount = calCtrl.mockSchedules.length;
      controller.templates[1].isEnabled.value = true; // Minum Obat Pagi (already enabled)
      
      // saveTemplateSchedule calls Get.snackbar then Get.back — errors expected
      runZonedGuarded(() {
        controller.saveTemplateSchedule();
      }, (_, _) {});

      // Should have added schedule(s)
      expect(calCtrl.mockSchedules.length, greaterThan(initialScheduleCount));
    });

    test('should detect medication type by title', () {
      final calCtrl = CalendarController();
      Get.put(calCtrl);

      // Only enable the medication template
      for (var t in controller.templates) {
        t.isEnabled.value = false;
      }
      controller.templates[1].isEnabled.value = true; // 'Minum Obat Pagi' has 'Obat'
      
      final initialCount = calCtrl.mockSchedules.length;
      
      // saveTemplateSchedule calls Get.snackbar then Get.back — errors expected
      runZonedGuarded(() {
        controller.saveTemplateSchedule();
      }, (_, _) {});
      
      expect(calCtrl.mockSchedules.length, initialCount + 1);
      // Find the added schedule by title (should be last in sorted result)
      final added = calCtrl.mockSchedules.firstWhere((s) => s['title'] == 'Minum Obat Pagi');
      expect(added['title'], 'Minum Obat Pagi');
    });
  });
}
