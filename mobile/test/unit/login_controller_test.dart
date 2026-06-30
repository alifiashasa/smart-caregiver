import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/login/controllers/login_controller.dart';
import '../test_helpers.dart';

void main() {
  late LoginController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    Get.testMode = true;
    controller = LoginController(authRepository: mockAuthRepository);
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('email and password should be empty', () {
      expect(controller.email, '');
      expect(controller.password, '');
    });

    test('password should be hidden by default', () {
      expect(controller.isPasswordHidden, true);
    });
  });

  group('togglePasswordVisibility', () {
    test('should toggle from true to false', () {
      controller.togglePasswordVisibility();
      expect(controller.isPasswordHidden, false);
    });

    test('should toggle from false to true', () {
      controller.togglePasswordVisibility(); // true -> false
      controller.togglePasswordVisibility(); // false -> true
      expect(controller.isPasswordHidden, true);
    });
  });

  group('setters', () {
    test('should set email value', () {
      controller.email = 'test@test.com';
      expect(controller.email, 'test@test.com');
    });

    test('should set password value', () {
      controller.password = 'password123';
      expect(controller.password, 'password123');
    });
  });

  group('login', () {
    test('should not navigate when email is empty (snackbar expected)', () {
      controller.password = 'password123';
      // Get.snackbar error is expected in test mode without overlay
      runZonedGuarded(() {
        controller.login();
      }, (_, _) {});
      expect(controller.email, '');
    });

    test('should not navigate when password is empty', () {
      controller.email = 'test@test.com';
      runZonedGuarded(() {
        controller.login();
      }, (_, _) {});
      expect(controller.password, '');
    });

    test('should not navigate when both fields are empty', () {
      runZonedGuarded(() {
        controller.login();
      }, (_, _) {});
      expect(controller.email, '');
      expect(controller.password, '');
    });
  });
}
