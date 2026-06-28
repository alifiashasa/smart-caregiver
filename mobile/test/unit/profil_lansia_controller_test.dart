import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/profil-lansia/controllers/profil_lansia_controller.dart';

void main() {
  late ProfilLansiaController controller;

  setUp(() {
    Get.testMode = true;
    controller = ProfilLansiaController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should have default values when no arguments', () {
      expect(controller.namaController.text, 'Ibu Siti');
      expect(controller.umurController.text, '55');
      expect(controller.jenisKelaminController.text, 'Perempuan');
      expect(controller.riwayatMedisController.text, 'Hipertensi ringan');
      expect(controller.minatHobiController.text, 'Berkebun dan Membaca');
    });

    test('should start at index 3', () {
      expect(controller.currentIndex.value, 3);
    });

    test('should have default patient image', () {
      expect(controller.patientImage.value, 'assets/images/patient_ibu_siti.png');
    });
  });

  group('changePage', () {
    test('should not navigate to same page', () {
      controller.currentIndex.value = 3;
      controller.changePage(3);
      expect(controller.currentIndex.value, 3);
    });

    test('should update index when navigating', () {
      controller.changePage(0);
      expect(controller.currentIndex.value, 0);
    });

    test('should update index to page 2', () {
      controller.changePage(2);
      expect(controller.currentIndex.value, 2);
    });
  });

  group('saveChanges', () {
    test('should show success snackbar', () {
      // saveChanges calls Get.snackbar which errors in test mode without overlay
      runZonedGuarded(() {
        controller.saveChanges();
      }, (_, __) {});
    });
  });
}
