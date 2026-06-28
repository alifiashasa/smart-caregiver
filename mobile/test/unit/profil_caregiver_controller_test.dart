import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/profil-caregiver/controllers/profil_caregiver_controller.dart';

void main() {
  late ProfilCaregiverController controller;

  setUp(() {
    Get.testMode = true;
    controller = ProfilCaregiverController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  test('logout should navigate to login', () {
    expect(() => controller.logout(), returnsNormally);
  });

  test('initial count should be 0', () {
    expect(controller.count.value, 0);
  });

  test('increment should work', () {
    controller.increment();
    expect(controller.count.value, 1);
  });
}
