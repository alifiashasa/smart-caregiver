import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/data/models/elderly_id_args.dart';

void main() {
  group('ElderlyIdArgs', () {
    test('parses elderly id from route map', () {
      final args = ElderlyIdArgs.fromMap({'elderly_id': 123});

      expect(args.elderlyId, '123');
      expect(args.isValid, isTrue);
    });

    test('detects invalid empty route args', () {
      final args = ElderlyIdArgs.fromMap({});

      expect(args.elderlyId, isEmpty);
      expect(args.isValid, isFalse);
    });

    test('serializes to route map', () {
      const args = ElderlyIdArgs(elderlyId: 'elderly-1');

      expect(args.toMap(), {'elderly_id': 'elderly-1'});
    });
  });
}
