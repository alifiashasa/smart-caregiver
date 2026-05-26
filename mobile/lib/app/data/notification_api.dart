import 'api_client.dart';

class NotificationApi {
  final ApiClient _client = ApiClient();

  /// GET /notifications
  Future<Map<String, dynamic>> getNotifications({
    int limit = 20,
    int offset = 0,
    bool unreadOnly = false,
  }) async {
    final params = 'limit=$limit&offset=$offset&unread_only=$unreadOnly';
    final response = await _client.get(
      '/notifications?$params',
      authenticated: true,
    );

    if (response['error'] == true) return response;

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// GET /notifications/unread-count
  Future<Map<String, dynamic>> getUnreadCount() async {
    final response = await _client.get(
      '/notifications/unread-count',
      authenticated: true,
    );

    if (response['error'] == true) return response;

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// PATCH /notifications/{id}/read
  Future<Map<String, dynamic>> markAsRead(String notificationId) async {
    final response = await _client.patch(
      '/notifications/$notificationId/read',
      body: {},
      authenticated: true,
    );

    if (response['error'] == true) return response;

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// PATCH /notifications/read-all
  Future<Map<String, dynamic>> markAllAsRead() async {
    final response = await _client.patch(
      '/notifications/read-all',
      body: {},
      authenticated: true,
    );

    if (response['error'] == true) return response;

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// GET /notification-preferences
  Future<Map<String, dynamic>> getPreferences() async {
    final response = await _client.get(
      '/notification-preferences',
      authenticated: true,
    );

    if (response['error'] == true) return response;

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// PUT /notification-preferences
  Future<Map<String, dynamic>> updatePreference({
    required String notificationType,
    bool? emailEnabled,
    bool? pushEnabled,
    bool? inAppEnabled,
  }) async {
    final response = await _client.put(
      '/notification-preferences',
      body: {
        'notification_type': notificationType,
        if (emailEnabled != null) 'email_enabled': emailEnabled,
        if (pushEnabled != null) 'push_enabled': pushEnabled,
        if (inAppEnabled != null) 'in_app_enabled': inAppEnabled,
      },
      authenticated: true,
    );

    if (response['error'] == true) return response;

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }
}
