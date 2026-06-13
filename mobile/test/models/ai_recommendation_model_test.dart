import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/data/models/ai_recommendation_model.dart';

void main() {
  group('AiRecommendationModel', () {
    test('parses recommendation response', () {
      final model = AiRecommendationModel.fromJson({
        'id': 'rec-1',
        'elderly_id': 'elderly-1',
        'activity_name': 'Jalan pagi',
        'category': 'physical',
        'description': 'Aktivitas ringan',
        'duration_minutes': '30',
        'frequency_suggestion': '3x seminggu',
        'ai_reasoning': 'Baik untuk mobilitas',
        'status': 'pending',
        'generated_at': '2026-06-13T08:00:00Z',
        'created_at': '2026-06-13T08:00:00Z',
      });

      expect(model.id, 'rec-1');
      expect(model.activityName, 'Jalan pagi');
      expect(model.durationMinutes, 30);
      expect(model.isPending, isTrue);
      expect(model.displayReason, 'Baik untuk mobilitas');
    });

    test('copyWith updates status', () {
      final model = AiRecommendationModel.fromJson({
        'id': 'rec-1',
        'elderly_id': 'elderly-1',
        'activity_name': 'Musik santai',
        'category': 'music',
        'status': 'pending',
        'generated_at': '2026-06-13T08:00:00Z',
        'created_at': '2026-06-13T08:00:00Z',
      });

      final approved = model.copyWith(status: 'approved');

      expect(approved.id, model.id);
      expect(approved.isApproved, isTrue);
    });
  });
}
