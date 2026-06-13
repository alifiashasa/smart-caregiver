class ScheduleModel {
  const ScheduleModel({
    required this.id,
    required this.title,
    required this.scheduleType,
    required this.scheduledAt,
    required this.isCompleted,
    required this.isActive,
    this.elderlyId,
    this.description,
    this.durationMinutes,
    this.alarms = const [],
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id']?.toString() ?? '',
      elderlyId: json['elderly_id']?.toString(),
      title: json['title'] as String? ?? '',
      scheduleType: json['schedule_type'] as String? ?? '',
      scheduledAt: _readDateTime(json['scheduled_at']) ?? DateTime.now(),
      durationMinutes: _readInt(json['duration_minutes']),
      isCompleted: json['is_completed'] == true,
      isActive: json['is_active'] != false,
      description: json['description'] as String?,
      alarms: json['alarms'] is List
          ? List<Map<String, dynamic>>.from(
              (json['alarms'] as List).whereType<Map>().map(
                (alarm) => Map<String, dynamic>.from(alarm),
              ),
            )
          : const [],
    );
  }

  final String id;
  final String? elderlyId;
  final String title;
  final String scheduleType;
  final DateTime scheduledAt;
  final int? durationMinutes;
  final bool isCompleted;
  final bool isActive;
  final String? description;
  final List<Map<String, dynamic>> alarms;

  ScheduleModel copyWith({bool? isCompleted}) {
    return ScheduleModel(
      id: id,
      elderlyId: elderlyId,
      title: title,
      scheduleType: scheduleType,
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive,
      description: description,
      alarms: alarms,
    );
  }

  Map<String, dynamic> toLegacyMap() {
    return {
      'id': id,
      'elderly_id': elderlyId,
      'title': title,
      'schedule_type': scheduleType,
      'scheduled_at': scheduledAt,
      'duration_minutes': durationMinutes,
      'is_completed': isCompleted,
      'description': description,
      'is_active': isActive,
      'alarms': alarms,
    };
  }

  static DateTime? _readDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toLocal();
  }

  static int? _readInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
