import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('parses current user response', () {
      final model = UserModel.fromJson({
        'id': 'user-1',
        'email': 'caregiver@example.com',
        'full_name': 'Caregiver Test',
        'is_email_verified': true,
        'has_password': true,
        'created_at': '2026-06-13T08:00:00Z',
      });

      expect(model.id, 'user-1');
      expect(model.email, 'caregiver@example.com');
      expect(model.displayName, 'Caregiver Test');
      expect(model.isEmailVerified, isTrue);
    });

    test('uses email as fallback display name', () {
      final model = UserModel.fromJson({
        'id': 'user-1',
        'email': 'caregiver@example.com',
        'full_name': '',
        'is_email_verified': true,
        'has_password': true,
        'created_at': '2026-06-13T08:00:00Z',
      });

      expect(model.displayName, 'caregiver@example.com');
    });
  });
}
