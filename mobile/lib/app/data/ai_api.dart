import 'api_client.dart';

class AiApi {
  final ApiClient _client = ApiClient();

  /// POST /elderly/{elderlyId}/recommendations/generate
  Future<Map<String, dynamic>> generateRecommendation({
    required String elderlyId,
    String? additionalContext,
  }) async {
    final response = await _client.post(
      '/elderly/$elderlyId/recommendations/generate',
      body: {
        if (additionalContext != null && additionalContext.isNotEmpty)
          'additional_context': additionalContext,
      },
      authenticated: true,
    );

    if (response['error'] == true) return response;

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// GET /elderly/{elderlyId}/recommendations
  Future<Map<String, dynamic>> getRecommendations(
    String elderlyId, {
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    if (status != null) queryParams['status'] = status;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    final response = await _client.get(
      '/elderly/$elderlyId/recommendations?$queryString',
      authenticated: true,
    );

    if (response['error'] == true) return response;

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// GET /elderly/{elderlyId}/recommendations/{id}
  Future<Map<String, dynamic>> getRecommendation(
    String elderlyId,
    String recommendationId,
  ) async {
    final response = await _client.get(
      '/elderly/$elderlyId/recommendations/$recommendationId',
      authenticated: true,
    );

    if (response['error'] == true) return response;

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// POST /elderly/{elderlyId}/recommendations/{id}/approve
  Future<Map<String, dynamic>> approveRecommendation({
    required String elderlyId,
    required String recommendationId,
    required String scheduledAt,
    int? durationMinutes,
    List<int>? reminderMinutes,
  }) async {
    final response = await _client.post(
      '/elderly/$elderlyId/recommendations/$recommendationId/approve',
      body: {
        'scheduled_at': scheduledAt,
        'duration_minutes': ?durationMinutes,
        if (reminderMinutes != null && reminderMinutes.isNotEmpty)
          'reminder_minutes': reminderMinutes,
      },
      authenticated: true,
    );

    if (response['error'] == true) return response;

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// POST /elderly/{elderlyId}/recommendations/{id}/reject
  Future<Map<String, dynamic>> rejectRecommendation({
    required String elderlyId,
    required String recommendationId,
    String? reason,
  }) async {
    final response = await _client.post(
      '/elderly/$elderlyId/recommendations/$recommendationId/reject',
      body: {if (reason != null && reason.isNotEmpty) 'reason': reason},
      authenticated: true,
    );

    if (response['error'] == true) return response;

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }
}
