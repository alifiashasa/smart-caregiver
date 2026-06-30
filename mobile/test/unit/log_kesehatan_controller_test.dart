import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile/app/modules/log-kesehatan/controllers/log_kesehatan_controller.dart';
import '../test_helpers.dart';

void main() {
  late LogKesehatanController controller;
  late MockHealthRepository mockHealthRepository;

  setUp(() {
    mockHealthRepository = MockHealthRepository();
    Get.testMode = true;
    controller = LogKesehatanController(healthRepository: mockHealthRepository);
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
}
