class AiRecommendationModel {
  const AiRecommendationModel({
    required this.id,
    required this.elderlyId,
    required this.activityName,
    required this.category,
    required this.status,
    required this.generatedAt,
    required this.createdAt,
    this.description,
    this.durationMinutes,
    this.frequencySuggestion,
    this.aiReasoning,
    this.aiModelVersion,
    this.aiPromptVersion,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
  });

  factory AiRecommendationModel.fromJson(Map<String, dynamic> json) {
    return AiRecommendationModel(
      id: json['id']?.toString() ?? '',
      elderlyId: json['elderly_id']?.toString() ?? '',
      activityName: json['activity_name'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      description: json['description'] as String? ?? json['desc'] as String?,
      durationMinutes: _readInt(json['duration_minutes']),
      frequencySuggestion: json['frequency_suggestion'] as String?,
      aiReasoning: json['ai_reasoning'] as String?,
      aiModelVersion: json['ai_model_version'] as String?,
      aiPromptVersion: json['ai_prompt_version'] as String?,
      status: json['status'] as String? ?? 'pending',
      approvedBy: json['approved_by']?.toString(),
      approvedAt: _readDateTime(json['approved_at']),
      rejectionReason: json['rejection_reason'] as String?,
      generatedAt: _readDateTime(json['generated_at']) ?? DateTime.now(),
      createdAt: _readDateTime(json['created_at']) ?? DateTime.now(),
    );
  }

  final String id;
  final String elderlyId;
  final String activityName;
  final String category;
  final String? description;
  final int? durationMinutes;
  final String? frequencySuggestion;
  final String? aiReasoning;
  final String? aiModelVersion;
  final String? aiPromptVersion;
  final String status;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final DateTime generatedAt;
  final DateTime createdAt;

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  String get displayReason => aiReasoning ?? description ?? '';
  int get scheduleDurationMinutes => durationMinutes ?? 30;

  AiRecommendationModel copyWith({String? status}) {
    return AiRecommendationModel(
      id: id,
      elderlyId: elderlyId,
      activityName: activityName,
      category: category,
      description: description,
      durationMinutes: durationMinutes,
      frequencySuggestion: frequencySuggestion,
      aiReasoning: aiReasoning,
      aiModelVersion: aiModelVersion,
      aiPromptVersion: aiPromptVersion,
      status: status ?? this.status,
      approvedBy: approvedBy,
      approvedAt: approvedAt,
      rejectionReason: rejectionReason,
      generatedAt: generatedAt,
      createdAt: createdAt,
    );
  }

  static int? _readInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static DateTime? _readDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toLocal();
  }
}
