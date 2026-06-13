import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/data/models/dashboard_elderly_model.dart';

void main() {
  group('DashboardElderlyModel', () {
    test('parses dashboard json safely', () {
      final model = DashboardElderlyModel.fromJson({
        'elderly_id': 'elderly-1',
        'full_name': 'Ibu Siti',
        'age': 72,
        'gender': 'female',
        'mobility_level': 'assisted',
        'latest_health_status': 'needs_attention',
        'latest_recorded_at': '2026-06-13T10:00:00Z',
      });

      expect(model.elderlyId, 'elderly-1');
      expect(model.fullName, 'Ibu Siti');
      expect(model.ageLabel, '72 Tahun');
      expect(model.needsAttention, isTrue);
      expect(model.latestRecordedAt, isNotNull);
    });

    test('builds route arguments for patient shell navigation', () {
      final model = DashboardElderlyModel.fromJson({
        'elderly_id': 'elderly-1',
        'full_name': 'Pak Joko',
        'age': '68',
        'mobility_level': 'independent',
      });

      expect(model.toRouteArguments(), containsPair('elderly_id', 'elderly-1'));
      expect(model.toRouteArguments(), containsPair('name', 'Pak Joko'));
      expect(model.toRouteArguments(), containsPair('age', '68'));
    });
  });
}
