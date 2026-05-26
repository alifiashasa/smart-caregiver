import 'api_client.dart';

class HealthApi {
  final ApiClient _client = ApiClient();

  /// POST /health/records
  Future<Map<String, dynamic>> createRecord({
    required int elderlyId,
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
        if (systolicBp != null) 'systolic_bp': systolicBp,
        if (diastolicBp != null) 'diastolic_bp': diastolicBp,
        if (heartRate != null) 'heart_rate': heartRate,
        if (spo2Level != null) 'spo2_level': spo2Level,
        if (bloodSugar != null) 'blood_sugar': bloodSugar,
        if (cholesterol != null) 'cholesterol': cholesterol,
        if (uricAcid != null) 'uric_acid': uricAcid,
        if (bodyWeight != null) 'body_weight': bodyWeight,
        if (bodyTemperature != null) 'body_temperature': bodyTemperature,
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
  Future<Map<String, dynamic>> getRecords(int elderlyId) async {
    final response = await _client.get(
      '/elderly/$elderlyId/health/records',
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
  Future<Map<String, dynamic>> getLatest(int elderlyId) async {
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
