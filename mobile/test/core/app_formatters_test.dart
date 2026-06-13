import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/core/formatters/app_formatters.dart';

void main() {
  group('AppFormatters', () {
    test('formats health statuses', () {
      expect(AppFormatters.healthStatusLabel('normal'), 'NORMAL');
      expect(AppFormatters.healthStatusLabel('warning'), 'WASPADA');
      expect(
        AppFormatters.healthStatusTitle('needs_attention'),
        'Perlu Perhatian',
      );
      expect(AppFormatters.isAttentionStatus('critical'), isTrue);
      expect(AppFormatters.isAttentionStatus('normal'), isFalse);
    });

    test('formats recommendation labels', () {
      expect(AppFormatters.recommendationCategoryLabel('physical'), 'Fisik');
      expect(AppFormatters.recommendationStatusLabel('approved'), 'Disetujui');
      expect(AppFormatters.durationMinutesLabel(30), '30 menit');
      expect(AppFormatters.durationMinutesLabel(90), '1 jam 30 menit');
      expect(AppFormatters.durationMinutesLabel(120), '2 jam');
    });

    test('formats notification type', () {
      expect(
        AppFormatters.notificationTypeLabel('critical_alert'),
        'Peringatan Kritis',
      );
      expect(AppFormatters.notificationTypeLabel('unknown'), 'Notifikasi');
    });
  });
}
