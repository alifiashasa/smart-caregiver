import 'api_client.dart';

class HealthApi {
  final ApiClient _client = ApiClient();

  /// POST /health/records
  Future<Map<String, dynamic>> createRecord({
    required String elderlyId,
    double? systolicBp,
    double? diastolicBp,
    double? heartRate,
    double? spo2Level,
    double? bloodSugar,
    double? cholesterol,
    double? uricAcid,
    double? bodyWeight,
    double? bodyTemperature,
    String? dailyNotes,
    String? complaints,
  }) async {
    final response = await _client.post(
      '/health/records',
      body: {
        'elderly_id': elderlyId,
        'systolic_bp': ?systolicBp,
        'diastolic_bp': ?diastolicBp,
        'heart_rate': ?heartRate,
        'spo2_level': ?spo2Level,
        'blood_sugar': ?bloodSugar,
        'cholesterol': ?cholesterol,
        'uric_acid': ?uricAcid,
        'body_weight': ?bodyWeight,
        'body_temperature': ?bodyTemperature,
        if (dailyNotes != null && dailyNotes.isNotEmpty)
          'daily_notes': dailyNotes,
        if (complaints != null && complaints.isNotEmpty)
          'complaints': complaints,
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

  /// GET /elderly/{elderlyId}/health/records
  Future<Map<String, dynamic>> getRecords(
    String elderlyId, {
    int? limit,
  }) async {
    final query = limit != null ? '?limit=$limit' : '';
    final response = await _client.get(
      '/elderly/$elderlyId/health/records$query',
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

  /// GET /elderly/{elderlyId}/health/latest
  Future<Map<String, dynamic>> getLatest(String elderlyId) async {
    final response = await _client.get(
      '/elderly/$elderlyId/health/latest',
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
