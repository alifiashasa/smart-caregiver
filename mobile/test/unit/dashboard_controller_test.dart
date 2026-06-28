import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/dashboard/controllers/dashboard_controller.dart';

void main() {
  late DashboardController controller;

  setUp(() {
    Get.testMode = true;
    controller = DashboardController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should have default patient data', () {
      expect(controller.patientName.value, 'Ibu Siti');
      expect(controller.patientAge.value, '55 Tahun');
      expect(controller.patientGender.value, 'Perempuan');
      expect(controller.patientImage.value, 'assets/images/patient_ibu_siti.png');
    });

    test('should start at index 0', () {
      expect(controller.currentIndex.value, 0);
    });

    test('should have 7 Hari as default trend filter', () {
      expect(controller.selectedTrendFilter.value, '7 Hari');
    });

    test('should have 8 health metrics', () {
      expect(controller.healthMetrics.length, 8);
    });

    test('health metrics should contain all expected types', () {
      final ids = controller.healthMetrics.map((m) => m['id']).toSet();
      expect(ids, containsAll(['cholesterol', 'tensi', 'uric_acid', 'blood_sugar',
                               'body_temp', 'spo2', 'weight', 'heart_rate']));
    });
  });

  group('updateHealthMetric', () {
    test('should update existing metric value', () {
      controller.updateHealthMetric('cholesterol', '200');
      final metric = controller.healthMetrics.firstWhere((m) => m['id'] == 'cholesterol');
      expect(metric['value'], '200');
    });

    test('should not update when new value is empty', () {
      controller.updateHealthMetric('cholesterol', '');
      final metric = controller.healthMetrics.firstWhere((m) => m['id'] == 'cholesterol');
      expect(metric['value'], '180');
    });

    test('should not crash with non-existent metric', () {
      final initialLength = controller.healthMetrics.length;
      controller.updateHealthMetric('nonexistent', '100');
      expect(controller.healthMetrics.length, initialLength);
    });

    test('should update multiple metrics independently', () {
      controller.updateHealthMetric('cholesterol', '200');
      controller.updateHealthMetric('tensi', '130/85');
      controller.updateHealthMetric('heart_rate', '80');

      expect(
        controller.healthMetrics.firstWhere((m) => m['id'] == 'cholesterol')['value'],
        '200',
      );
      expect(
        controller.healthMetrics.firstWhere((m) => m['id'] == 'tensi')['value'],
        '130/85',
      );
      expect(
        controller.healthMetrics.firstWhere((m) => m['id'] == 'heart_rate')['value'],
        '80',
      );
    });
  });

  group('changePage', () {
    test('should not navigate when index is same as current', () {
      controller.currentIndex.value = 0;
      controller.changePage(0);
      expect(controller.currentIndex.value, 0);
    });

    test('should update index when navigating to different page', () {
      controller.changePage(1);
      expect(controller.currentIndex.value, 1);
    });

    test('should update index when navigating to page 3', () {
      controller.changePage(3);
      expect(controller.currentIndex.value, 3);
    });
  });

  group('selectedTrendFilter', () {
    test('should update trend filter value', () {
      controller.selectedTrendFilter.value = '30 Hari';
      expect(controller.selectedTrendFilter.value, '30 Hari');
    });
  });
}
