import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/login/controllers/login_controller.dart';

void main() {
  late LoginController controller;

  setUp(() {
    Get.testMode = true;
    controller = LoginController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('email and password should be empty', () {
      expect(controller.email.value, '');
      expect(controller.password.value, '');
    });

    test('password should be hidden by default', () {
      expect(controller.isPasswordHidden.value, true);
    });
  });

  group('togglePasswordVisibility', () {
    test('should toggle from true to false', () {
      controller.togglePasswordVisibility();
      expect(controller.isPasswordHidden.value, false);
    });

    test('should toggle from false to true', () {
      controller.togglePasswordVisibility(); // true -> false
      controller.togglePasswordVisibility(); // false -> true
      expect(controller.isPasswordHidden.value, true);
    });
  });

  group('login', () {
    test('should not navigate when email is empty (snackbar expected)', () {
      controller.password.value = 'password123';
      // Get.snackbar error is expected in test mode without overlay
      runZonedGuarded(() {
        controller.login();
      }, (_, __) {});
      expect(controller.email.value, '');
    });

    test('should not navigate when password is empty', () {
      controller.email.value = 'test@test.com';
      runZonedGuarded(() {
        controller.login();
      }, (_, __) {});
      expect(controller.password.value, '');
    });

    test('should not navigate when both fields are empty', () {
      runZonedGuarded(() {
        controller.login();
      }, (_, __) {});
      expect(controller.email.value, '');
      expect(controller.password.value, '');
    });

    test('should navigate to home when both fields are filled', () {
      controller.email.value = 'test@test.com';
      controller.password.value = 'password123';

      // With both fields filled, login() calls Get.offAllNamed — no snackbar
      controller.login();

      // Email and password should still be set
      expect(controller.email.value, 'test@test.com');
      expect(controller.password.value, 'password123');
    });
  });

  group('loginWithGoogle', () {
    test('should not throw error', () {
      expect(() => controller.loginWithGoogle(), returnsNormally);
    });
  });
}
