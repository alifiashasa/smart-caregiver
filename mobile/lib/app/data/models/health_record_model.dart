class HealthRecordModel {
  const HealthRecordModel({
    required this.id,
    required this.elderlyId,
    required this.recordedAt,
    required this.healthStatus,
    this.recordedBy,
    this.createdAt,
    this.systolicBp,
    this.diastolicBp,
    this.bloodSugar,
    this.heartRate,
    this.bodyTemperature,
    this.bodyWeight,
    this.cholesterol,
    this.uricAcid,
    this.spo2Level,
    this.dailyNotes,
    this.complaints,
    this.cardioScore,
    this.metabolicScore,
    this.infectionScore,
    this.fuzzyFinalScore,
  });

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) {
    return HealthRecordModel(
      id: json['id']?.toString() ?? '',
      elderlyId: json['elderly_id']?.toString() ?? '',
      recordedBy: json['recorded_by']?.toString(),
      recordedAt: _readDateTime(json['recorded_at']) ?? DateTime.now(),
      createdAt: _readDateTime(json['created_at']),
      systolicBp: _readDouble(json['systolic_bp']),
      diastolicBp: _readDouble(json['diastolic_bp']),
      bloodSugar: _readDouble(json['blood_sugar']),
      heartRate: _readDouble(json['heart_rate']),
      bodyTemperature: _readDouble(json['body_temperature']),
      bodyWeight: _readDouble(json['body_weight']),
      cholesterol: _readDouble(json['cholesterol']),
      uricAcid: _readDouble(json['uric_acid']),
      spo2Level: _readDouble(json['spo2_level']),
      dailyNotes: json['daily_notes'] as String?,
      complaints: json['complaints'] as String?,
      healthStatus: json['health_status'] as String? ?? 'normal',
      cardioScore: _readDouble(json['cardio_score']),
      metabolicScore: _readDouble(json['metabolic_score']),
      infectionScore: _readDouble(json['infection_score']),
      fuzzyFinalScore: _readDouble(json['fuzzy_final_score']),
    );
  }

  final String id;
  final String elderlyId;
  final String? recordedBy;
  final DateTime recordedAt;
  final DateTime? createdAt;
  final double? systolicBp;
  final double? diastolicBp;
  final double? bloodSugar;
  final double? heartRate;
  final double? bodyTemperature;
  final double? bodyWeight;
  final double? cholesterol;
  final double? uricAcid;
  final double? spo2Level;
  final String? dailyNotes;
  final String? complaints;
  final String healthStatus;
  final double? cardioScore;
  final double? metabolicScore;
  final double? infectionScore;
  final double? fuzzyFinalScore;

  bool get isCritical => healthStatus == 'critical';
  bool get needsAttention =>
      healthStatus == 'critical' || healthStatus == 'needs_attention';

  static double? _readDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static DateTime? _readDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toLocal();
  }
}
