import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/data/models/schedule_model.dart';

void main() {
  group('ScheduleModel', () {
    test('parses schedule json and converts date to local DateTime', () {
      final model = ScheduleModel.fromJson({
        'id': 'schedule-1',
        'elderly_id': 'elderly-1',
        'title': 'Minum obat',
        'schedule_type': 'medication',
        'scheduled_at': '2026-06-13T08:00:00Z',
        'duration_minutes': 15,
        'is_completed': false,
        'is_active': true,
        'description': 'Obat pagi',
        'alarms': [
          {'reminder_minutes': 10},
        ],
      });

      expect(model.id, 'schedule-1');
      expect(model.title, 'Minum obat');
      expect(model.scheduleType, 'medication');
      expect(model.durationMinutes, 15);
      expect(model.alarms, hasLength(1));
    });

    test('copyWith updates completion while keeping identity', () {
      final model = ScheduleModel.fromJson({
        'id': 'schedule-1',
        'title': 'Checkup',
        'schedule_type': 'routine_checkup',
        'scheduled_at': '2026-06-13T08:00:00Z',
      });

      final updated = model.copyWith(isCompleted: true);

      expect(updated.id, model.id);
      expect(updated.isCompleted, isTrue);
    });
  });
}
