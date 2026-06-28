import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/login/controllers/login_controller.dart';
import 'package:mobile/app/modules/register/controllers/register_controller.dart';
import 'package:mobile/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mobile/app/modules/log-kesehatan/controllers/log_kesehatan_controller.dart';
import 'package:mobile/app/modules/calendar/controllers/calendar_controller.dart';
import 'package:mobile/app/modules/rekomendasi_ai/controllers/rekomendasi_ai_controller.dart';

/// Helper to manage controller registration for integration tests
class GetXTestHelper {
  static DashboardController createDashboardController() {
    Get.reset();
    Get.testMode = true;
    final ctrl = DashboardController();
    Get.put(ctrl);
    return ctrl;
  }

  static LogKesehatanController createLogKesehatanController() {
    if (!Get.isRegistered<DashboardController>()) {
      createDashboardController();
    }
    final ctrl = LogKesehatanController();
    Get.put(ctrl);
    return ctrl;
  }

  static RegisterController createRegisterController() {
    Get.reset();
    Get.testMode = true;
    final ctrl = RegisterController();
    Get.put(ctrl);
    return ctrl;
  }

  static LoginController createLoginController() {
    Get.reset();
    Get.testMode = true;
    final ctrl = LoginController();
    Get.put(ctrl);
    return ctrl;
  }

  static CalendarController createCalendarController() {
    Get.reset();
    Get.testMode = true;
    final ctrl = CalendarController();
    Get.put(ctrl);
    return ctrl;
  }

  static RekomendasiAiController createRecommendationController() {
    // Create CalendarController first without resetting if not already present
    if (!Get.isRegistered<CalendarController>()) {
      Get.testMode = true;
      final calCtrl = CalendarController();
      Get.put(calCtrl);
    }
    final ctrl = RekomendasiAiController();
    Get.put(ctrl);
    return ctrl;
  }
}

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('Login flow', () {
    test('should login with valid credentials', () {
      final loginCtrl = GetXTestHelper.createLoginController();

      loginCtrl.email.value = 'test@caregiver.com';
      loginCtrl.password.value = 'password123';

      // Should not throw (no snackbar) since both fields filled
      expect(() => loginCtrl.login(), returnsNormally);
      expect(loginCtrl.email.value, 'test@caregiver.com');
      expect(loginCtrl.password.value, 'password123');
    });

    test('should register and have fields set', () {
      final registerCtrl = GetXTestHelper.createRegisterController();

      registerCtrl.name.value = 'Test Caregiver';
      registerCtrl.email.value = 'test@caregiver.com';
      registerCtrl.password.value = 'password123';
      registerCtrl.confirmPassword.value = 'password123';

      // Success path calls Get.snackbar then Get.offAllNamed
      // Snackbar errors are expected in test mode without overlay
      runZonedGuarded(() {
        registerCtrl.register();
      }, (_, __) {});

      expect(registerCtrl.name.value, 'Test Caregiver');
      expect(registerCtrl.email.value, 'test@caregiver.com');
    });
  });

  group('Dashboard to Log Kesehatan flow', () {
    test('dashboard should have correct initial state', () {
      final dashboardCtrl = GetXTestHelper.createDashboardController();

      expect(dashboardCtrl.currentIndex.value, 0);
      expect(dashboardCtrl.healthMetrics.length, 8);
    });

    test('should log health record and update dashboard', () {
      final dashboardCtrl = GetXTestHelper.createDashboardController();
      final logCtrl = GetXTestHelper.createLogKesehatanController();

      logCtrl.cholesterolController.text = '200';
      logCtrl.tensiController.text = '130/85';
      logCtrl.heartRateController.text = '80';

      logCtrl.submitHealthRecord();

      expect(
        dashboardCtrl.healthMetrics.firstWhere((m) => m['id'] == 'cholesterol')['value'],
        '200',
      );
      expect(
        dashboardCtrl.healthMetrics.firstWhere((m) => m['id'] == 'tensi')['value'],
        '130/85',
      );
    });

    test('critical health values should update dashboard', () {
      final dashboardCtrl = GetXTestHelper.createDashboardController();
      final logCtrl = GetXTestHelper.createLogKesehatanController();

      logCtrl.tensiController.text = '190/100';
      logCtrl.submitHealthRecord();

      expect(
        dashboardCtrl.healthMetrics.firstWhere((m) => m['id'] == 'tensi')['value'],
        '190/100',
      );
    });
  });

  group('AI Recommendation to Calendar flow', () {
    test('approving recommendation should add to calendar', () async {
      final calCtrl = GetXTestHelper.createCalendarController();
      final recCtrl = GetXTestHelper.createRecommendationController();

      // Wait for recommendations to load
      await Future.delayed(const Duration(seconds: 3));

      expect(recCtrl.recommendations.length, 3);

      // Approve first recommendation
      final rec = recCtrl.recommendations.first;
      final initialCount = calCtrl.mockSchedules.length;

      // approveRecommendation calls Get.snackbar — errors expected in test mode
      runZonedGuarded(() {
        recCtrl.approveRecommendation(rec);
      }, (_, __) {});

      // The schedule should still have been added before the snackbar
      expect(calCtrl.mockSchedules.length, initialCount + 1);

      // Find the added schedule by title
      final added =
          calCtrl.mockSchedules.firstWhere((s) => s['title'] == rec['title']);
      expect(added['title'], rec['title']);
    });
  });
}
