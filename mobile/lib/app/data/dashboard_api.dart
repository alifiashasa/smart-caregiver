import 'api_client.dart';

class DashboardApi {
  final ApiClient _client = ApiClient();

  /// GET /dashboard/overview
  Future<Map<String, dynamic>> getOverview() async {
    final response = await _client.get(
      '/dashboard/overview',
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// GET /elderly/{elderlyId}/health/trends?range={range}
  Future<Map<String, dynamic>> getTrends(
    String elderlyId, {
    String range = '7d',
  }) async {
    final response = await _client.get(
      '/elderly/$elderlyId/health/trends?range=$range',
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }
}
