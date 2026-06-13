import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/data/models/patient_route_args.dart';

void main() {
  group('PatientRouteArgs', () {
    test('parses legacy route map safely', () {
      final args = PatientRouteArgs.fromMap({
        'elderly_id': 123,
        'name': 'Ibu Siti',
        'age': 72,
        'gender': 'female',
      });

      expect(args.elderlyId, '123');
      expect(args.name, 'Ibu Siti');
      expect(args.age, '72');
      expect(args.gender, 'female');
      expect(args.image, PatientRouteArgs.defaultImage);
    });

    test('serializes to route map', () {
      const args = PatientRouteArgs(
        elderlyId: 'elderly-1',
        name: 'Pak Joko',
        age: '68',
        gender: 'male',
        image: 'image.png',
      );

      expect(args.toMap(), containsPair('elderly_id', 'elderly-1'));
      expect(args.toMap(), containsPair('name', 'Pak Joko'));
      expect(args.toMap(), containsPair('image', 'image.png'));
    });
  });
}
