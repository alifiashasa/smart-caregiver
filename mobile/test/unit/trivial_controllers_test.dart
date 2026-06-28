import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/detail-history/controllers/detail_history_controller.dart';
import 'package:mobile/app/modules/notifikasi/controllers/notifikasi_controller.dart';
import 'package:mobile/app/modules/jadwal-lansia/controllers/jadwal_lansia_controller.dart';
import 'package:mobile/app/modules/success_log_kesehatan/controllers/success_log_kesehatan_controller.dart';

void main() {
  group('DetailHistoryController', () {
    late DetailHistoryController controller;

    setUp(() {
      Get.testMode = true;
      controller = DetailHistoryController();
      Get.put(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test('initial count should be 0', () {
      expect(controller.count.value, 0);
    });

    test('increment should increase count', () {
      controller.increment();
      expect(controller.count.value, 1);
    });

    test('multiple increments', () {
      controller.increment();
      controller.increment();
      expect(controller.count.value, 2);
    });
  });

  group('NotifikasiController', () {
    late NotifikasiController controller;

    setUp(() {
      Get.testMode = true;
      controller = NotifikasiController();
      Get.put(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test('initial count should be 0', () {
      expect(controller.count.value, 0);
    });

    test('increment should work', () {
      controller.increment();
      expect(controller.count.value, 1);
    });
  });

  group('JadwalLansiaController', () {
    late JadwalLansiaController controller;

    setUp(() {
      Get.testMode = true;
      controller = JadwalLansiaController();
      Get.put(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test('initial count should be 0', () {
      expect(controller.count.value, 0);
    });

    test('increment should work', () {
      controller.increment();
      expect(controller.count.value, 1);
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

    test('initial count should be 0', () {
      expect(controller.count.value, 0);
    });

    test('increment should work', () {
      controller.increment();
      expect(controller.count.value, 1);
    });
  });
}
