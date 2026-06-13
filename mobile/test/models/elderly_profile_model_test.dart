import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/data/models/elderly_profile_model.dart';

void main() {
  group('ElderlyProfileModel', () {
    test('parses profile json', () {
      final model = ElderlyProfileModel.fromJson({
        'id': 'elderly-1',
        'full_name': 'Ibu Siti',
        'age': '72',
        'mobility_level': 'assisted',
        'status': 'active',
      });

      expect(model.id, 'elderly-1');
      expect(model.fullName, 'Ibu Siti');
      expect(model.age, 72);
      expect(model.ageLabel, '72 Tahun');
      expect(model.isActive, isTrue);
    });
  });
}
