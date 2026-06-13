import 'patient_route_args.dart';

class DashboardElderlyModel {
  const DashboardElderlyModel({
    required this.elderlyId,
    required this.fullName,
    required this.age,
    required this.mobilityLevel,
    this.gender,
    this.photoUrl,
    this.latestHealthStatus,
    this.latestRecordedAt,
  });

  factory DashboardElderlyModel.fromJson(Map<String, dynamic> json) {
    return DashboardElderlyModel(
      elderlyId: json['elderly_id']?.toString() ?? '',
      fullName: json['full_name'] as String? ?? '',
      age: _readInt(json['age']),
      gender: json['gender'] as String?,
      photoUrl: json['photo_url'] as String?,
      mobilityLevel: json['mobility_level'] as String? ?? 'independent',
      latestHealthStatus: json['latest_health_status'] as String?,
      latestRecordedAt: _readDateTime(json['latest_recorded_at']),
    );
  }

  final String elderlyId;
  final String fullName;
  final int age;
  final String? gender;
  final String? photoUrl;
  final String mobilityLevel;
  final String? latestHealthStatus;
  final DateTime? latestRecordedAt;

  String get ageLabel => '$age Tahun';
  bool get needsAttention =>
      latestHealthStatus == 'critical' ||
      latestHealthStatus == 'needs_attention';

  Map<String, dynamic> toJson() {
    return {
      'elderly_id': elderlyId,
      'full_name': fullName,
      'age': age,
      'gender': gender,
      'photo_url': photoUrl,
      'mobility_level': mobilityLevel,
      'latest_health_status': latestHealthStatus,
      'latest_recorded_at': latestRecordedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toRouteArguments() {
    return PatientRouteArgs(
      elderlyId: elderlyId,
      name: fullName,
      age: age.toString(),
      gender: gender ?? 'Laki-laki',
      image: PatientRouteArgs.defaultImage,
    ).toMap();
  }

  static int _readInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _readDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
