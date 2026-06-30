import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/profil-lansia/controllers/profil_lansia_controller.dart';
import 'package:mobile/app/modules/patient_shell/controllers/patient_shell_controller.dart';
import '../test_helpers.dart';

void main() {
  late ProfilLansiaController controller;
  late MockElderlyRepository mockElderlyRepository;

  setUp(() {
    mockElderlyRepository = MockElderlyRepository();
    Get.testMode = true;
    final shell = PatientShellController();
    shell.patientName.value = 'Ibu Siti';
    shell.patientAge.value = '55 Tahun';
    shell.patientGender.value = 'Perempuan';
    Get.put(shell);
    controller = ProfilLansiaController(elderlyRepository: mockElderlyRepository);
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
    });

    test('should start at index 0', () {
      expect(controller.selectedProfileTab, 0);
    });

    test('should have default patient image', () {
      expect(controller.patientImage, 'assets/images/patient_ibu_siti.png');
    });
  });

  group('changeProfileTab', () {
    test('should not change to same tab', () {
      expect(controller.selectedProfileTab, 0);
      controller.changeProfileTab(0);
      expect(controller.selectedProfileTab, 0);
    });

    test('should update tab when changing', () {
      controller.changeProfileTab(2);
      expect(controller.selectedProfileTab, 2);
    });

    test('should update index to page 1', () {
      controller.changeProfileTab(1);
      expect(controller.selectedProfileTab, 1);
    });
  });
}
