import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/data/models/health_record_model.dart';

void main() {
  group('HealthRecordModel', () {
    test('parses vital signs and flags critical status', () {
      final model = HealthRecordModel.fromJson({
        'id': 'record-1',
        'elderly_id': 'elderly-1',
        'recorded_at': '2026-06-13T08:00:00Z',
        'health_status': 'critical',
        'systolic_bp': 180,
        'blood_sugar': '250.5',
        'fuzzy_final_score': 91.2,
      });

      expect(model.id, 'record-1');
      expect(model.systolicBp, 180);
      expect(model.bloodSugar, 250.5);
      expect(model.fuzzyFinalScore, 91.2);
      expect(model.isCritical, isTrue);
      expect(model.needsAttention, isTrue);
    });
  });
}
