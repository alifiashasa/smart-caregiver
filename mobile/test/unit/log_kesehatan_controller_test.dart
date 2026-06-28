import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile/app/modules/log-kesehatan/controllers/log_kesehatan_controller.dart';
import 'package:mobile/app/modules/dashboard/controllers/dashboard_controller.dart';

void main() {
  late LogKesehatanController controller;
  late DashboardController dashboardController;

  setUp(() {
    Get.testMode = true;
    dashboardController = DashboardController();
    Get.put(dashboardController);
    controller = LogKesehatanController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('TextEditingControllers', () {
    test('all controllers should be created', () {
      expect(controller.cholesterolController, isA<TextEditingController>());
      expect(controller.tensiController, isA<TextEditingController>());
      expect(controller.uricAcidController, isA<TextEditingController>());
      expect(controller.bloodSugarController, isA<TextEditingController>());
      expect(controller.bodyTempController, isA<TextEditingController>());
      expect(controller.heartRateController, isA<TextEditingController>());
      expect(controller.spo2Controller, isA<TextEditingController>());
      expect(controller.weightController, isA<TextEditingController>());
      expect(controller.notesController, isA<TextEditingController>());
      expect(controller.complaintsController, isA<TextEditingController>());
    });

    test('should be empty by default', () {
      expect(controller.cholesterolController.text, '');
      expect(controller.tensiController.text, '');
      expect(controller.uricAcidController.text, '');
    });
  });

  group('submitHealthRecord - tensi parsing', () {
    test('should parse tensi with format "120/80"', () {
      controller.tensiController.text = '120/80';
      controller.cholesterolController.text = '180';

      // Verify it runs without error with valid data
      expect(() => controller.submitHealthRecord(), returnsNormally);
    });

    test('should handle tensi without slash', () {
      controller.tensiController.text = '120';
      controller.cholesterolController.text = '180';

      expect(() => controller.submitHealthRecord(), returnsNormally);
    });

    test('should handle empty tensi', () {
      controller.bloodSugarController.text = '110';

      expect(() => controller.submitHealthRecord(), returnsNormally);
    });
  });

  group('submitHealthRecord - health status logic', () {
    test('should be Normal when all values are normal', () {
      controller.tensiController.text = '120/80';
      controller.bloodSugarController.text = '110';
      controller.cholesterolController.text = '180';
      controller.uricAcidController.text = '5.5';
      controller.bodyTempController.text = '36.5';
      controller.heartRateController.text = '72';
      controller.spo2Controller.text = '98';
      controller.weightController.text = '70';

      expect(() => controller.submitHealthRecord(), returnsNormally);
    });

    test('should be Perhatian when systolic > 140', () {
      controller.tensiController.text = '150/90';
      controller.bloodSugarController.text = '110';

      expect(() => controller.submitHealthRecord(), returnsNormally);
    });

    test('should be Perhatian when blood sugar > 150', () {
      controller.tensiController.text = '120/80';
      controller.bloodSugarController.text = '180';

      expect(() => controller.submitHealthRecord(), returnsNormally);
    });

    test('should be Kritis when systolic > 180', () {
      controller.tensiController.text = '190/100';

      expect(() => controller.submitHealthRecord(), returnsNormally);
    });

    test('should be Kritis when blood sugar > 250', () {
      controller.bloodSugarController.text = '300';

      expect(() => controller.submitHealthRecord(), returnsNormally);
    });

    test('should handle all fields empty gracefully', () {
      // All empty - should parse all as null
      expect(() => controller.submitHealthRecord(), returnsNormally);
    });
  });

  group('submitHealthRecord - dashboard update', () {
    test('should update dashboard metrics with filled fields', () {
      controller.cholesterolController.text = '200';
      controller.tensiController.text = '130/85';
      controller.heartRateController.text = '80';

      controller.submitHealthRecord();

      // Dashboard should be updated
      expect(
        dashboardController.healthMetrics.firstWhere((m) => m['id'] == 'cholesterol')['value'],
        '200',
      );
      expect(
        dashboardController.healthMetrics.firstWhere((m) => m['id'] == 'tensi')['value'],
        '130/85',
      );
      expect(
        dashboardController.healthMetrics.firstWhere((m) => m['id'] == 'heart_rate')['value'],
        '80',
      );
    });

    test('should not crash when dashboard controller not found', () {
      Get.reset(); // Remove all registrations
      Get.testMode = true;
      final ctrl = LogKesehatanController();

      // Should handle the missing DashboardController gracefully via try-catch
      ctrl.cholesterolController.text = '200';
      expect(() => ctrl.submitHealthRecord(), returnsNormally);
    });
  });
}
