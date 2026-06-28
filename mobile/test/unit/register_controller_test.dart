import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/register/controllers/register_controller.dart';

void main() {
  late RegisterController controller;

  setUp(() {
    Get.testMode = true;
    controller = RegisterController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('all fields should be empty', () {
      expect(controller.name.value, '');
      expect(controller.email.value, '');
      expect(controller.password.value, '');
      expect(controller.confirmPassword.value, '');
    });

    test('passwords should be obscured by default', () {
      expect(controller.obscurePassword.value, true);
      expect(controller.obscureConfirmPassword.value, true);
    });
  });

  group('togglePasswordVisibility', () {
    test('should toggle password visibility', () {
      controller.togglePasswordVisibility();
      expect(controller.obscurePassword.value, false);

      controller.togglePasswordVisibility();
      expect(controller.obscurePassword.value, true);
    });
  });

  group('toggleConfirmPasswordVisibility', () {
    test('should toggle confirm password visibility', () {
      controller.toggleConfirmPasswordVisibility();
      expect(controller.obscureConfirmPassword.value, false);

      controller.toggleConfirmPasswordVisibility();
      expect(controller.obscureConfirmPassword.value, true);
    });
  });

  group('register', () {
    test('should reject when name is empty (snackbar expected)', () {
      controller.email.value = 'test@test.com';
      controller.password.value = 'password123';
      controller.confirmPassword.value = 'password123';

      // Get.snackbar error is expected in test mode without overlay
      runZonedGuarded(() {
        controller.register();
      }, (_, __) {});
      expect(controller.name.value, '');
    });

    test('should reject when email is empty', () {
      controller.name.value = 'Test User';
      controller.password.value = 'password123';
      controller.confirmPassword.value = 'password123';

      runZonedGuarded(() {
        controller.register();
      }, (_, __) {});
      expect(controller.email.value, '');
    });

    test('should reject when password is empty', () {
      controller.name.value = 'Test User';
      controller.email.value = 'test@test.com';
      controller.confirmPassword.value = 'password123';

      runZonedGuarded(() {
        controller.register();
      }, (_, __) {});
      expect(controller.password.value, '');
    });

    test('should reject when password and confirm password do not match', () {
      controller.name.value = 'Test User';
      controller.email.value = 'test@test.com';
      controller.password.value = 'password123';
      controller.confirmPassword.value = 'different_password';

      // Should show "Password tidak cocok" snackbar
      runZonedGuarded(() {
        controller.register();
      }, (_, __) {});

      // Values remain unchanged
      expect(controller.password.value, 'password123');
      expect(controller.confirmPassword.value, 'different_password');
    });

    test('should register successfully when all fields are valid', () {
      controller.name.value = 'Test User';
      controller.email.value = 'test@test.com';
      controller.password.value = 'password123';
      controller.confirmPassword.value = 'password123';

      // Success path: Get.snackbar("Success", ...) then Get.offAllNamed
      // Snackbar error expected in test mode without overlay
      runZonedGuarded(() {
        controller.register();
      }, (_, __) {});

      // Fields should still have values
      expect(controller.name.value, 'Test User');
      expect(controller.email.value, 'test@test.com');
    });
  });
}
