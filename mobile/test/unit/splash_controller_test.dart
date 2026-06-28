import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/splash/controllers/splash_controller.dart';

void main() {
  late SplashController controller;

  setUp(() {
    Get.testMode = true;
    controller = SplashController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  test('should create controller without error', () {
    expect(controller, isNotNull);
  });

  test('onReady should not throw error', () {
    // onReady schedules a 3-second delayed navigation
    // In test mode, Future.delayed still runs the timer
    // but Get.offAllNamed may not navigate without routing context
    // Just verify it doesn't crash
    expect(() => controller.onReady(), returnsNormally);
  });
}
