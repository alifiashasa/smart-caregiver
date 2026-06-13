import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/data/models/notification_model.dart';

void main() {
  group('NotificationModel', () {
    test('detects critical notification from type', () {
      final model = NotificationModel.fromJson({
        'id': 'notification-1',
        'notification_type': 'critical_alert',
        'title': 'Kritis',
        'body': 'Tekanan darah tinggi',
        'is_read': false,
        'created_at': '2026-06-13T08:00:00Z',
      });

      expect(model.isCritical, isTrue);
      expect(model.isRead, isFalse);
    });

    test('copyWith marks notification as read', () {
      final model = NotificationModel.fromJson({
        'id': 'notification-1',
        'notification_type': 'weekly_summary',
        'title': 'Ringkasan',
        'body': 'Ringkasan mingguan',
        'is_read': false,
        'created_at': '2026-06-13T08:00:00Z',
      });

      final updated = model.copyWith(isRead: true);

      expect(updated.id, model.id);
      expect(updated.isRead, isTrue);
    });
  });
}
