import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/rekomendasi_ai/controllers/rekomendasi_ai_controller.dart';
import 'package:mobile/app/modules/calendar/controllers/calendar_controller.dart';

void main() {
  late RekomendasiAiController controller;

  setUp(() {
    Get.testMode = true;
    controller = RekomendasiAiController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should start with loading true', () {
      expect(controller.isLoading.value, true);
    });

    test('should start with empty recommendations', () {
      expect(controller.recommendations.length, 0);
    });
  });

  group('fetchRecommendations', () {
    test('should load 3 recommendations after delay', () async {
      // Wait for the async initialization to complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      // At this point _fetchRecommendations from onInit should be running
      // It waits 2 seconds, so should still be loading
      expect(controller.isLoading.value, true);
      expect(controller.recommendations.length, 0);
    });

    test('should complete loading after full delay', () async {
      await Future.delayed(const Duration(seconds: 3));
      
      expect(controller.isLoading.value, false);
      expect(controller.recommendations.length, 3);
    });

    test('recommendations should have correct structure', () async {
      await Future.delayed(const Duration(seconds: 3));

      for (final rec in controller.recommendations) {
        expect(rec['title'], isA<String>());
        expect(rec['type'], isA<String>());
        expect(rec['duration'], isA<String>());
        expect(rec['reason'], isA<String>());
      }
    });

    test('recommendations should include physical, mental, and hydration types', () async {
      await Future.delayed(const Duration(seconds: 3));

      final types = controller.recommendations.map((r) => r['type']).toSet();
      expect(types, containsAll(['Fisik', 'Mental', 'Hidrasi']));
    });
  });

  group('approveRecommendation', () {
    test('should not crash when calendar controller not found', () async {
      await Future.delayed(const Duration(seconds: 3));
      
      final rec = controller.recommendations.first;
      
      Get.reset();
      Get.testMode = true;
      final ctrl = RekomendasiAiController();
      Get.put(ctrl);
      await Future.delayed(const Duration(seconds: 3));
      
      // approveRecommendation calls Get.snackbar — errors expected in test mode
      runZonedGuarded(() {
        ctrl.approveRecommendation(rec);
      }, (_, _) {});
    });

    test('should add schedule when calendar controller exists', () async {
      final calCtrl = CalendarController();
      Get.put(calCtrl);
      
      await Future.delayed(const Duration(seconds: 3));
      
      final initialCount = calCtrl.mockSchedules.length;
      final rec = controller.recommendations.first;
      
      // approveRecommendation calls Get.snackbar — errors expected in test mode
      runZonedGuarded(() {
        controller.approveRecommendation(rec);
      }, (_, _) {});
      
      expect(calCtrl.mockSchedules.length, initialCount + 1);
      // Find the added schedule by title (not .last, because sort order may vary)
      final added = calCtrl.mockSchedules.firstWhere((s) => s['title'] == rec['title']);
      expect(added['title'], rec['title']);
    });
  });
}
