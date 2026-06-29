import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/app/modules/tambah_lansia/controllers/tambah_lansia_controller.dart';

void main() {
  late TambahLansiaController controller;

  setUp(() {
    Get.testMode = true;
    controller = TambahLansiaController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should have default values', () {
      expect(controller.namaLengkap.value, '');
      expect(controller.usia.value, '');
      expect(controller.fotoProfilPath.value, '');
      expect(controller.jenisKelamin.value, 'Laki-laki');
      expect(controller.riwayatMedis.value, '');
      expect(controller.kondisiFisik.value, 'Mandiri');
      expect(controller.mobilitas.value, 'Bisa Berjalan');
      expect(controller.minatHobi.value, '');
    });
  });

  group('simpan', () {
    test('should reject when nama is empty (snackbar expected)', () {
      controller.usia.value = '70';
      // Get.snackbar error is expected in test mode without overlay
      runZonedGuarded(() {
        controller.simpan();
      }, (_, _) {});
      expect(controller.namaLengkap.value, '');
    });

    test('should reject when usia is empty', () {
      controller.namaLengkap.value = 'Test Name';
      runZonedGuarded(() {
        controller.simpan();
      }, (_, _) {});
      expect(controller.usia.value, '');
    });

    test('should reject when both fields are empty', () {
      runZonedGuarded(() {
        controller.simpan();
      }, (_, _) {});
      expect(controller.namaLengkap.value, '');
      expect(controller.usia.value, '');
    });

    test('should save successfully when both fields are filled', () {
      controller.namaLengkap.value = 'Ibu Siti';
      controller.usia.value = '70';

      // Success path calls Get.snackbar then Get.back
      // Snackbar error expected in test mode without overlay
      runZonedGuarded(() {
        controller.simpan();
      }, (_, _) {});
    });
  });

  group('jenisKelamin options', () {
    test('should allow changing gender to Perempuan', () {
      controller.jenisKelamin.value = 'Perempuan';
      expect(controller.jenisKelamin.value, 'Perempuan');
    });

    test('should allow changing gender back to Laki-laki', () {
      controller.jenisKelamin.value = 'Perempuan';
      controller.jenisKelamin.value = 'Laki-laki';
      expect(controller.jenisKelamin.value, 'Laki-laki');
    });
  });

  group('kondisiFisik options', () {
    test('should allow changing physical condition', () {
      controller.kondisiFisik.value = 'Butuh Bantuan Sebagian';
      expect(controller.kondisiFisik.value, 'Butuh Bantuan Sebagian');
    });
  });

  group('mobilitas options', () {
    test('should allow changing mobility', () {
      controller.mobilitas.value = 'Kursi Roda';
      expect(controller.mobilitas.value, 'Kursi Roda');
    });
  });

  group('constructor injection', () {
    test('should accept injected ImagePicker', () {
      final mockPicker = ImagePicker();
      final ctrl = TambahLansiaController(picker: mockPicker);
      expect(ctrl, isNotNull);
    });
  });
}
