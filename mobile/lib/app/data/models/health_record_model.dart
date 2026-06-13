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
    this.fuzzyAnalysis,
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
      fuzzyAnalysis: json['fuzzy_analysis'] is Map
          ? Map<String, dynamic>.from(json['fuzzy_analysis'] as Map)
          : null,
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
  final Map<String, dynamic>? fuzzyAnalysis;

  bool get isCritical => healthStatus == 'critical';
  bool get needsAttention =>
      healthStatus == 'critical' || healthStatus == 'needs_attention';

  Map<String, dynamic> toLegacyMap() {
    return {
      'id': id,
      'elderly_id': elderlyId,
      'recorded_by': recordedBy,
      'recorded_at': recordedAt.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'systolic_bp': systolicBp,
      'diastolic_bp': diastolicBp,
      'blood_sugar': bloodSugar,
      'heart_rate': heartRate,
      'body_temperature': bodyTemperature,
      'body_weight': bodyWeight,
      'cholesterol': cholesterol,
      'uric_acid': uricAcid,
      'spo2_level': spo2Level,
      'daily_notes': dailyNotes,
      'complaints': complaints,
      'health_status': healthStatus,
      'cardio_score': cardioScore,
      'metabolic_score': metabolicScore,
      'infection_score': infectionScore,
      'fuzzy_final_score': fuzzyFinalScore,
      'fuzzy_analysis': fuzzyAnalysis,
    };
  }

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
