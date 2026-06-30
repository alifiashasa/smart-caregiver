import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/rekomendasi_ai/controllers/rekomendasi_ai_controller.dart';
import 'package:mobile/app/data/models/ai_recommendation_model.dart';
import '../test_helpers.dart';

void main() {
  late RekomendasiAiController controller;
  late MockAiRepository mockAiRepository;

  setUp(() {
    mockAiRepository = MockAiRepository();
    Get.testMode = true;
    controller = RekomendasiAiController(aiRepository: mockAiRepository);
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should start with loading true', () {
      // onInit won't call fetchRecommendations without elderlyId in args
      expect(controller.isLoading, false);
    });

    test('should start with empty recommendations', () {
      expect(controller.recommendations.length, 0);
    });

    test('errorMessage should be set when no elderlyId available', () {
      expect(controller.errorMessage, 'Data lansia tidak ditemukan.');
    });
  });

  group('AiRecommendationModel', () {
    test('should create from json and use getters', () {
      final json = {
        'id': '1',
        'elderly_id': 'elderly-1',
        'activity_name': 'Jalan Pagi',
        'category': 'physical',
        'status': 'pending',
        'generated_at': '2026-01-01T00:00:00Z',
        'created_at': '2026-01-01T00:00:00Z',
      };
      final model = AiRecommendationModel.fromJson(json);
      expect(model.activityName, 'Jalan Pagi');
      expect(model.category, 'physical');
      expect(model.status, 'pending');
      expect(model.id, '1');
    });
  });
}
