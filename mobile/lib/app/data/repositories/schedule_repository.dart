import '../schedule_api.dart';

class ScheduleRepository {
  final ScheduleApi _api;

  ScheduleRepository() : _api = ScheduleApi();

  Future<Map<String, dynamic>> create({
    required String elderlyId,
    required String title,
    required String scheduleType,
    required DateTime scheduledAt,
    String? description,
    int? durationMinutes,
    String? recurrenceType,
    String? recurrenceRule,
    DateTime? recurrenceEndAt,
    List<int>? reminderMinutes,
  }) =>
      _api.create(
        elderlyId: elderlyId,
        title: title,
        scheduleType: scheduleType,
        scheduledAt: scheduledAt,
        description: description,
        durationMinutes: durationMinutes,
        recurrenceType: recurrenceType,
        recurrenceRule: recurrenceRule,
        recurrenceEndAt: recurrenceEndAt,
        reminderMinutes: reminderMinutes,
      );

  Future<Map<String, dynamic>> getSchedules(String elderlyId,
          {String? scheduleType,
          bool? isActive,
          String? fromDate,
          String? toDate,
          int limit = 50,
          int offset = 0}) =>
      _api.getSchedules(elderlyId,
          scheduleType: scheduleType,
          isActive: isActive,
          fromDate: fromDate,
          toDate: toDate,
          limit: limit,
          offset: offset);

  Future<Map<String, dynamic>> getById(String scheduleId) =>
      _api.getById(scheduleId);

  Future<Map<String, dynamic>> update(
    String id, {
    String? title,
    String? scheduleType,
    DateTime? scheduledAt,
    String? description,
    int? durationMinutes,
    String? recurrenceType,
    String? recurrenceRule,
    DateTime? recurrenceEndAt,
    bool? isActive,
    List<int>? reminderMinutes,
  }) =>
      _api.update(
        id,
        title: title,
        scheduleType: scheduleType,
        scheduledAt: scheduledAt,
        description: description,
        durationMinutes: durationMinutes,
        recurrenceType: recurrenceType,
        recurrenceRule: recurrenceRule,
        recurrenceEndAt: recurrenceEndAt,
        isActive: isActive,
        reminderMinutes: reminderMinutes,
      );

  Future<Map<String, dynamic>> delete(String id) => _api.delete(id);

  Future<Map<String, dynamic>> markComplete(String id) =>
      _api.markComplete(id);
}
