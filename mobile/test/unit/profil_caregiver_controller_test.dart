import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/profil-caregiver/controllers/profil_caregiver_controller.dart';
import '../test_helpers.dart';

void main() {
  late ProfilCaregiverController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    stubProfileControllerDeps(mockAuthRepository);
    Get.testMode = true;
    controller = ProfilCaregiverController(authRepository: mockAuthRepository);
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  test('should create controller without error', () {
    expect(controller, isNotNull);
  });

  test('logout should not throw error', () {
    // login dulu baru logout
    expect(controller, isNotNull);
    expect(() => controller.logout(), returnsNormally);
  });
}
