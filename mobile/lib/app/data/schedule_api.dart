import 'api_client.dart';

class ScheduleApi {
  final ApiClient _client = ApiClient();

  /// POST /elderly/{elderlyId}/schedules
  Future<Map<String, dynamic>> create({
    required int elderlyId,
    required String title,
    required String scheduleType,
    required DateTime scheduledAt,
    int? durationMinutes,
    String? description,
    String? recurrenceType,
    String? recurrenceRule,
    DateTime? recurrenceEndAt,
    List<int>? reminderMinutes,
  }) async {
    final response = await _client.post(
      '/elderly/$elderlyId/schedules',
      body: {
        'title': title,
        'schedule_type': scheduleType,
        'scheduled_at': scheduledAt.toIso8601String(),
        if (durationMinutes != null) 'duration_minutes': durationMinutes,
        if (description != null && description.isNotEmpty)
          'description': description,
        if (recurrenceType != null) 'recurrence_type': recurrenceType,
        if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
        if (recurrenceEndAt != null)
          'recurrence_end_at': recurrenceEndAt.toIso8601String(),
        if (reminderMinutes != null && reminderMinutes.isNotEmpty)
          'reminder_minutes': reminderMinutes,
      },
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// GET /elderly/{elderlyId}/schedules
  Future<Map<String, dynamic>> getSchedules(
    int elderlyId, {
    String? scheduleType,
    bool? isActive,
    String? fromDate,
    String? toDate,
    int limit = 50,
    int offset = 0,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    if (scheduleType != null) queryParams['schedule_type'] = scheduleType;
    if (isActive != null) queryParams['is_active'] = isActive.toString();
    if (fromDate != null) queryParams['from_date'] = fromDate;
    if (toDate != null) queryParams['to_date'] = toDate;

    final uri =
        '/elderly/$elderlyId/schedules?${Uri(queryParameters: queryParams).query}';

    final response = await _client.get(uri, authenticated: true);

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// GET /schedules/{scheduleId}
  Future<Map<String, dynamic>> getById(String scheduleId) async {
    final response =
        await _client.get('/schedules/$scheduleId', authenticated: true);

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// PUT /schedules/{scheduleId}
  Future<Map<String, dynamic>> update(
    String scheduleId, {
    String? title,
    String? scheduleType,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? description,
    String? recurrenceType,
    String? recurrenceRule,
    DateTime? recurrenceEndAt,
    bool? isActive,
    List<int>? reminderMinutes,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (scheduleType != null) body['schedule_type'] = scheduleType;
    if (scheduledAt != null) {
      body['scheduled_at'] = scheduledAt.toIso8601String();
    }
    if (durationMinutes != null) body['duration_minutes'] = durationMinutes;
    if (description != null) body['description'] = description;
    if (recurrenceType != null) body['recurrence_type'] = recurrenceType;
    if (recurrenceRule != null) body['recurrence_rule'] = recurrenceRule;
    if (recurrenceEndAt != null) {
      body['recurrence_end_at'] = recurrenceEndAt.toIso8601String();
    }
    if (isActive != null) body['is_active'] = isActive;
    if (reminderMinutes != null) body['reminder_minutes'] = reminderMinutes;

    final response = await _client.put(
      '/schedules/$scheduleId',
      body: body,
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// DELETE /schedules/{scheduleId}
  Future<Map<String, dynamic>> delete(String scheduleId) async {
    final response =
        await _client.delete('/schedules/$scheduleId', authenticated: true);

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// PATCH /schedules/{scheduleId}/complete
  Future<Map<String, dynamic>> markComplete(String scheduleId) async {
    final response = await _client.patch(
      '/schedules/$scheduleId/complete',
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }
}
