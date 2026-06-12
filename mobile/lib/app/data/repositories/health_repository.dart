import '../health_api.dart';

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
  }) =>
      _api.createRecord(
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

  Future<Map<String, dynamic>> getLatest(String elderlyId) =>
      _api.getLatest(elderlyId);
}
