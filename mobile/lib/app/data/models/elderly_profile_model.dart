class ElderlyProfileModel {
  const ElderlyProfileModel({
    required this.id,
    required this.fullName,
    required this.age,
    required this.mobilityLevel,
    required this.status,
    this.caregiverId,
    this.gender,
    this.photoUrl,
    this.medicalHistory,
    this.physicalCondition,
    this.hobbiesInterests,
    this.allergies,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.createdAt,
    this.updatedAt,
  });

  factory ElderlyProfileModel.fromJson(Map<String, dynamic> json) {
    return ElderlyProfileModel(
      id: json['id']?.toString() ?? '',
      caregiverId: json['caregiver_id']?.toString(),
      fullName: json['full_name'] as String? ?? '',
      age: _readInt(json['age']),
      gender: json['gender'] as String?,
      photoUrl: json['photo_url'] as String?,
      medicalHistory: json['medical_history'] as String?,
      physicalCondition: json['physical_condition'] as String?,
      mobilityLevel: json['mobility_level'] as String? ?? 'independent',
      hobbiesInterests: json['hobbies_interests'] as String?,
      allergies: json['allergies'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      status: json['status'] as String? ?? 'active',
      createdAt: _readDateTime(json['created_at']),
      updatedAt: _readDateTime(json['updated_at']),
    );
  }

  final String id;
  final String? caregiverId;
  final String fullName;
  final int age;
  final String? gender;
  final String? photoUrl;
  final String? medicalHistory;
  final String? physicalCondition;
  final String mobilityLevel;
  final String? hobbiesInterests;
  final String? allergies;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isActive => status == 'active';
  String get ageLabel => '$age Tahun';

  static int _readInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _readDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toLocal();
  }
}
