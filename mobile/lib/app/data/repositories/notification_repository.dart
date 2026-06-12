import '../notification_api.dart';

class NotificationRepository {
  final NotificationApi _api;

  NotificationRepository() : _api = NotificationApi();

  Future<Map<String, dynamic>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) =>
      _api.getNotifications(limit: limit, offset: offset);

  Future<Map<String, dynamic>> getUnreadCount() => _api.getUnreadCount();

  Future<Map<String, dynamic>> markAsRead(String id) => _api.markAsRead(id);

  Future<Map<String, dynamic>> markAllAsRead() => _api.markAllAsRead();
}
