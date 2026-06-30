import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/patient_detail/controllers/patient_detail_controller.dart';
import 'package:mobile/app/modules/patient_shell/controllers/patient_shell_controller.dart';
import '../test_helpers.dart';

void main() {
  late PatientDetailController controller;
  late MockElderlyRepository mockElderlyRepository;
  late MockHealthRepository mockHealthRepository;

  setUp(() {
    mockElderlyRepository = MockElderlyRepository();
    mockHealthRepository = MockHealthRepository();
    Get.testMode = true;
    Get.put(PatientShellController());
    controller = PatientDetailController(
      elderlyRepository: mockElderlyRepository,
      healthRepository: mockHealthRepository,
    );
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should have empty patient name initially', () {
      expect(controller.patientName, '');
    });

    test('should start with empty records', () {
      expect(controller.records.length, 0);
    });

    test('should have isLoading false', () {
      expect(controller.isLoading, false);
    });
  });
}
