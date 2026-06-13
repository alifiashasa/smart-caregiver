import '../../core/api_result.dart';
import '../ai_api.dart';
import '../models/ai_recommendation_model.dart';

class AiRepository {
  final AiApi _api;

  AiRepository() : _api = AiApi();

  Future<Map<String, dynamic>> getRecommendations(String elderlyId) =>
      _api.getRecommendations(elderlyId);

  Future<ApiResult<List<AiRecommendationModel>>> getRecommendationItems(
    String elderlyId,
  ) async {
    final response = await _api.getRecommendations(elderlyId);
    final result = response.toApiResult();

    return result.when(
      success: (data) {
        final rawList = data['recommendations'] as List<dynamic>? ?? [];
        final recommendations = rawList
            .whereType<Map>()
            .map(
              (item) => AiRecommendationModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
        return ApiResult.success(recommendations);
      },
      failure: (failure) => ApiResult.failure(
        failure.message,
        statusCode: failure.statusCode,
        sessionExpired: failure.sessionExpired,
        detailBody: failure.detailBody,
      ),
    );
  }

  Future<Map<String, dynamic>> generateRecommendation({
    required String elderlyId,
    String? additionalContext,
  }) => _api.generateRecommendation(
    elderlyId: elderlyId,
    additionalContext: additionalContext,
  );

  Future<Map<String, dynamic>> approveRecommendation({
    required String elderlyId,
    required String recommendationId,
    required String scheduledAt,
    int? durationMinutes,
    List<int>? reminderMinutes,
  }) => _api.approveRecommendation(
    elderlyId: elderlyId,
    recommendationId: recommendationId,
    scheduledAt: scheduledAt,
    durationMinutes: durationMinutes,
    reminderMinutes: reminderMinutes,
  );

  Future<Map<String, dynamic>> rejectRecommendation({
    required String elderlyId,
    required String recommendationId,
  }) => _api.rejectRecommendation(
    elderlyId: elderlyId,
    recommendationId: recommendationId,
  );
}
