import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/detail-history/controllers/detail_history_controller.dart';
import 'package:mobile/app/modules/notifikasi/controllers/notifikasi_controller.dart';
import 'package:mobile/app/modules/jadwal-lansia/controllers/jadwal_lansia_controller.dart';
import 'package:mobile/app/modules/success_log_kesehatan/controllers/success_log_kesehatan_controller.dart';
import '../test_helpers.dart';

void main() {
  group('DetailHistoryController', () {
    late DetailHistoryController controller;
    late MockHealthRepository mockHealthRepository;

    setUp(() {
      mockHealthRepository = MockHealthRepository();
      Get.testMode = true;
      controller = DetailHistoryController(healthRepository: mockHealthRepository);
      Get.put(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test('should create controller', () {
      expect(controller, isNotNull);
    });

    test('initial selectedIndex should be 0', () {
      expect(controller.selectedIndex, 0);
    });
  });

  group('NotifikasiController', () {
    late NotifikasiController controller;
    late MockNotificationRepository mockNotificationRepository;

    setUp(() {
      mockNotificationRepository = MockNotificationRepository();
      stubNotifikasiControllerDeps(mockNotificationRepository);
      Get.testMode = true;
      controller = NotifikasiController(
        notificationRepository: mockNotificationRepository,
      );
      Get.put(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test('should create controller', () {
      expect(controller, isNotNull);
    });

    test('initial notifications should be empty', () {
      expect(controller.notifications.length, 0);
    });
  });

  group('JadwalLansiaController', () {
    late JadwalLansiaController controller;
    late MockScheduleRepository mockScheduleRepository;

    setUp(() {
      mockScheduleRepository = MockScheduleRepository();
      Get.testMode = true;
      controller = JadwalLansiaController(scheduleRepository: mockScheduleRepository);
      Get.put(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test('should create controller', () {
      expect(controller, isNotNull);
    });

    test('initial type should be medication', () {
      expect(controller.selectedType, 'medication');
    });
  });

  group('SuccessLogKesehatanController', () {
    late SuccessLogKesehatanController controller;

    setUp(() {
      Get.testMode = true;
      controller = SuccessLogKesehatanController();
      Get.put(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test('should create controller', () {
      expect(controller, isNotNull);
    });

    test('initial health status should be Normal', () {
      expect(controller.healthStatus, 'Normal');
    });
  });
}
