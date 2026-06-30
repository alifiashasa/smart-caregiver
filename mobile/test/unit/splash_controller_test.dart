import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/splash/controllers/splash_controller.dart';
import '../test_helpers.dart';

void main() {
  late SplashController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    Get.testMode = true;
    controller = SplashController(authRepository: mockAuthRepository);
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  test('should create controller without error', () {
    expect(controller, isNotNull);
  });
}
