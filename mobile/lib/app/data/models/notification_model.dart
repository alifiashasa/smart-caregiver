class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.notificationType,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.elderlyId,
    this.priority,
    this.payload,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      elderlyId: json['elderly_id']?.toString(),
      notificationType: json['notification_type'] as String? ?? '',
      priority: json['priority'] as String?,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      payload: json['payload'] is Map
          ? Map<String, dynamic>.from(json['payload'] as Map)
          : null,
      isRead: json['is_read'] == true,
      readAt: _readDateTime(json['read_at']),
      createdAt: _readDateTime(json['created_at']) ?? DateTime.now(),
    );
  }

  final String id;
  final String? elderlyId;
  final String notificationType;
  final String? priority;
  final String title;
  final String body;
  final Map<String, dynamic>? payload;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  bool get isCritical =>
      notificationType == 'critical_alert' || priority == 'high';

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      elderlyId: elderlyId,
      notificationType: notificationType,
      priority: priority,
      title: title,
      body: body,
      payload: payload,
      isRead: isRead ?? this.isRead,
      readAt: readAt,
      createdAt: createdAt,
    );
  }

  static DateTime? _readDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toLocal();
  }
}
