import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/core/api_result.dart';

void main() {
  group('ApiMapResult', () {
    test('converts success map to ApiSuccess', () {
      final result = {
        'error': false,
        'statusCode': 200,
        'data': {'message': 'ok'},
      }.toApiResult();

      expect(result, isA<ApiSuccess<Map<String, dynamic>>>());
      result.when(
        success: (data) => expect(data['message'], 'ok'),
        failure: (_) => fail('should not fail'),
      );
    });

    test('converts error map to ApiFailure', () {
      final result = {
        'error': true,
        'statusCode': 401,
        'message': 'Sesi habis',
        'session_expired': true,
      }.toApiResult();

      expect(result, isA<ApiFailure<Map<String, dynamic>>>());
      result.when(
        success: (_) => fail('should not succeed'),
        failure: (failure) {
          expect(failure.message, 'Sesi habis');
          expect(failure.statusCode, 401);
          expect(failure.sessionExpired, isTrue);
        },
      );
    });
  });
}
