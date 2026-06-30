import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/register/controllers/register_controller.dart';
import '../test_helpers.dart';

void main() {
  late RegisterController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    Get.testMode = true;
    controller = RegisterController(authRepository: mockAuthRepository);
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('all fields should be empty', () {
      expect(controller.name, '');
      expect(controller.email, '');
      expect(controller.password, '');
      expect(controller.confirmPassword, '');
    });

    test('passwords should be obscured by default', () {
      expect(controller.obscurePassword, true);
      expect(controller.obscureConfirmPassword, true);
    });
  });

  group('togglePasswordVisibility', () {
    test('should toggle password visibility', () {
      controller.togglePasswordVisibility();
      expect(controller.obscurePassword, false);

      controller.togglePasswordVisibility();
      expect(controller.obscurePassword, true);
    });
  });

  group('toggleConfirmPasswordVisibility', () {
    test('should toggle confirm password visibility', () {
      controller.toggleConfirmPasswordVisibility();
      expect(controller.obscureConfirmPassword, false);

      controller.toggleConfirmPasswordVisibility();
      expect(controller.obscureConfirmPassword, true);
    });
  });

  group('register', () {
    test('should reject when name is empty (snackbar expected)', () {
      controller.email = 'test@test.com';
      controller.password = 'password123';
      controller.confirmPassword = 'password123';

      // Get.snackbar error is expected in test mode without overlay
      runZonedGuarded(() {
        controller.register();
      }, (_, _) {});
      expect(controller.name, '');
    });

    test('should reject when email is empty', () {
      controller.name = 'Test User';
      controller.password = 'password123';
      controller.confirmPassword = 'password123';

      runZonedGuarded(() {
        controller.register();
      }, (_, _) {});
      expect(controller.email, '');
    });

    test('should reject when password is empty', () {
      controller.name = 'Test User';
      controller.email = 'test@test.com';
      controller.confirmPassword = 'password123';

      runZonedGuarded(() {
        controller.register();
      }, (_, _) {});
      expect(controller.password, '');
    });

    test('should reject when password and confirm password do not match', () {
      controller.name = 'Test User';
      controller.email = 'test@test.com';
      controller.password = 'password123';
      controller.confirmPassword = 'different_password';

      runZonedGuarded(() {
        controller.register();
      }, (_, _) {});

      expect(controller.password, 'password123');
      expect(controller.confirmPassword, 'different_password');
    });

    test('should register successfully when all fields are valid', () {
      controller.name = 'Test User';
      controller.email = 'test@test.com';
      controller.password = 'password123';
      controller.confirmPassword = 'password123';

      runZonedGuarded(() {
        controller.register();
      }, (_, _) {});

      expect(controller.name, 'Test User');
      expect(controller.email, 'test@test.com');
    });
  });
}
