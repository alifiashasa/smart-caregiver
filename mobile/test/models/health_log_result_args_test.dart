import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/data/models/health_log_result_args.dart';

void main() {
  group('HealthLogResultArgs', () {
    test('parses result route map safely', () {
      final args = HealthLogResultArgs.fromMap({
        'status': 'Kritis',
        'message': 'Butuh perhatian',
        'cardio_score': 88,
        'metabolic_score': '70.5',
        'infection_score': null,
        'elderly_id': 'elderly-1',
        'name': 'Ibu Siti',
      });

      expect(args.status, 'Kritis');
      expect(args.cardioScore, 88);
      expect(args.metabolicScore, 70.5);
      expect(args.infectionScore, 0);
      expect(args.elderlyId, 'elderly-1');
    });

    test('serializes to route map', () {
      const args = HealthLogResultArgs(
        status: 'Normal',
        message: 'Aman',
        cardioScore: 10,
        metabolicScore: 20,
        infectionScore: 30,
        elderlyId: 'elderly-1',
        patientName: 'Pak Joko',
      );

      expect(args.toMap(), containsPair('status', 'Normal'));
      expect(args.toMap(), containsPair('elderly_id', 'elderly-1'));
      expect(args.toMap(), containsPair('name', 'Pak Joko'));
    });
  });
}
