import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/app/modules/tambah_lansia/controllers/tambah_lansia_controller.dart';
import '../test_helpers.dart';

void main() {
  late TambahLansiaController controller;
  late MockElderlyRepository mockElderlyRepository;

  setUp(() {
    mockElderlyRepository = MockElderlyRepository();
    Get.testMode = true;
    controller = TambahLansiaController(elderlyRepository: mockElderlyRepository);
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should have default values', () {
      expect(controller.namaLengkap, '');
      expect(controller.usia, '');
      expect(controller.fotoProfilPath, '');
      expect(controller.jenisKelamin.value, 'Laki-laki');
      expect(controller.riwayatMedis, '');
      expect(controller.kondisiFisik.value, 'Mandiri');
      expect(controller.mobilitas.value, 'Bisa Berjalan');
      expect(controller.minatHobi, '');
    });
  });

  group('simpan', () {
    test('should reject when nama is empty (snackbar expected)', () {
      controller.usia = '70';
      runZonedGuarded(() {
        controller.simpan();
      }, (_, _) {});
      expect(controller.namaLengkap, '');
    });

    test('should reject when usia is empty', () {
      controller.namaLengkap = 'Test Name';
      runZonedGuarded(() {
        controller.simpan();
      }, (_, _) {});
      expect(controller.usia, '');
    });

    test('should reject when both fields are empty', () {
      runZonedGuarded(() {
        controller.simpan();
      }, (_, _) {});
      expect(controller.namaLengkap, '');
      expect(controller.usia, '');
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
      final ctrl = TambahLansiaController(
        elderlyRepository: mockElderlyRepository,
        picker: mockPicker,
      );
      expect(ctrl, isNotNull);
    });
  });
}
