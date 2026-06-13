import '../../core/api_result.dart';
import '../health_api.dart';
import '../models/health_record_model.dart';

class HealthRepository {
  final HealthApi _api;

  HealthRepository() : _api = HealthApi();

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
  }) => _api.createRecord(
    elderlyId: elderlyId,
    systolicBp: systolicBp,
    diastolicBp: diastolicBp,
    heartRate: heartRate,
    spo2Level: spo2Level,
    bloodSugar: bloodSugar,
    cholesterol: cholesterol,
    uricAcid: uricAcid,
    bodyWeight: bodyWeight,
    bodyTemperature: bodyTemperature,
    dailyNotes: dailyNotes,
    complaints: complaints,
  );

  Future<Map<String, dynamic>> getRecords(String elderlyId, {int? limit}) =>
      _api.getRecords(elderlyId, limit: limit);

  Future<ApiResult<List<HealthRecordModel>>> getRecordItems(
    String elderlyId, {
    int? limit,
  }) async {
    final response = await _api.getRecords(elderlyId, limit: limit);
    final result = response.toApiResult();

    return result.when(
      success: (data) {
        final rawList = data['records'] as List<dynamic>? ?? [];
        final records = rawList
            .whereType<Map>()
            .map(
              (item) =>
                  HealthRecordModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
        return ApiResult.success(records);
      },
      failure: (failure) => ApiResult.failure(
        failure.message,
        statusCode: failure.statusCode,
        sessionExpired: failure.sessionExpired,
        detailBody: failure.detailBody,
      ),
    );
  }

  Future<Map<String, dynamic>> getLatest(String elderlyId) =>
      _api.getLatest(elderlyId);

  Future<ApiResult<HealthRecordModel>> getLatestRecord(String elderlyId) async {
    final response = await _api.getLatest(elderlyId);
    final result = response.toApiResult();

    return result.when(
      success: (data) => ApiResult.success(HealthRecordModel.fromJson(data)),
      failure: (failure) => ApiResult.failure(
        failure.message,
        statusCode: failure.statusCode,
        sessionExpired: failure.sessionExpired,
        detailBody: failure.detailBody,
      ),
    );
  }
}
