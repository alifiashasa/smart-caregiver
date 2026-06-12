import '../ai_api.dart';

class AiRepository {
  final AiApi _api;

  AiRepository() : _api = AiApi();

  Future<Map<String, dynamic>> getRecommendations(String elderlyId) =>
      _api.getRecommendations(elderlyId);

  Future<Map<String, dynamic>> generateRecommendation({
    required String elderlyId,
    String? additionalContext,
  }) =>
      _api.generateRecommendation(
        elderlyId: elderlyId,
        additionalContext: additionalContext,
      );

  Future<Map<String, dynamic>> approveRecommendation({
    required String elderlyId,
    required String recommendationId,
    required String scheduledAt,
    int? durationMinutes,
    List<int>? reminderMinutes,
  }) =>
      _api.approveRecommendation(
        elderlyId: elderlyId,
        recommendationId: recommendationId,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes,
        reminderMinutes: reminderMinutes,
      );

  Future<Map<String, dynamic>> rejectRecommendation({
    required String elderlyId,
    required String recommendationId,
  }) =>
      _api.rejectRecommendation(
        elderlyId: elderlyId,
        recommendationId: recommendationId,
      );
}
