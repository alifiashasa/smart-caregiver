import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/core/validators/app_validators.dart';

void main() {
  group('AppValidators', () {
    test('validates email', () {
      expect(AppValidators.email('caregiver@example.com'), isNull);
      expect(AppValidators.email('invalid'), 'Format email tidak valid');
      expect(AppValidators.email(''), 'Email harus diisi');
    });

    test('validates minimum length', () {
      expect(AppValidators.minLength('abcdef', 'Password', 6), isNull);
      expect(
        AppValidators.minLength('abc', 'Password', 6),
        'Password minimal 6 karakter',
      );
    });

    test('validates positive integer', () {
      expect(AppValidators.positiveInt('72', 'Usia'), isNull);
      expect(
        AppValidators.positiveInt('abc', 'Usia'),
        'Usia harus berupa angka',
      );
      expect(AppValidators.positiveInt('0', 'Usia'), 'Usia harus lebih dari 0');
    });
  });
}
