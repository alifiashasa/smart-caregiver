import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/patient_detail/controllers/patient_detail_controller.dart';

void main() {
  late PatientDetailController controller;

  setUp(() {
    Get.testMode = true;
    controller = PatientDetailController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should have default patient name', () {
      expect(controller.patientName.value, 'Budi Santoso');
    });

    test('should start at index 2', () {
      expect(controller.currentIndex.value, 2);
    });

    test('should have 4 records', () {
      expect(controller.records.length, 4);
    });

    test('records should have correct structure', () {
      final firstRecord = controller.records[0];
      expect(firstRecord, containsPair('status', 'Perlu Perhatian'));
      expect(firstRecord, containsPair('date', '24 Oktober 2026'));
      expect(firstRecord, containsPair('tensi', '135/88'));
      expect(firstRecord, containsPair('suhu', '36.5°C'));
      expect(firstRecord['symptoms'], isA<List>());
    });

    test('last records should be normal', () {
      for (int i = 1; i < controller.records.length; i++) {
        expect(controller.records[i]['status'], 'Normal');
      }
    });
  });

  group('changePage', () {
    test('should not navigate to same page', () {
      controller.currentIndex.value = 2;
      controller.changePage(2);
      expect(controller.currentIndex.value, 2);
    });

    test('should change index when navigating', () {
      controller.changePage(0);
      expect(controller.currentIndex.value, 0);
    });
  });
}
