import '../../core/api_result.dart';
import '../models/notification_model.dart';
import '../notification_api.dart';

class NotificationRepository {
  final NotificationApi _api;

  NotificationRepository() : _api = NotificationApi();

  Future<Map<String, dynamic>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) => _api.getNotifications(limit: limit, offset: offset);

  Future<ApiResult<({List<NotificationModel> notifications, int total})>>
  getNotificationItems({int limit = 20, int offset = 0}) async {
    final response = await getNotifications(limit: limit, offset: offset);
    final result = response.toApiResult();

    return result.when(
      success: (data) {
        final rawList = data['notifications'] as List<dynamic>? ?? [];
        final notifications = rawList
            .whereType<Map>()
            .map(
              (item) =>
                  NotificationModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
        return ApiResult.success((
          notifications: notifications,
          total: data['total'] as int? ?? 0,
        ));
      },
      failure: (failure) => ApiResult.failure(
        failure.message,
        statusCode: failure.statusCode,
        sessionExpired: failure.sessionExpired,
        detailBody: failure.detailBody,
      ),
    );
  }

  Future<Map<String, dynamic>> getUnreadCount() => _api.getUnreadCount();

  Future<Map<String, dynamic>> markAsRead(String id) => _api.markAsRead(id);

  Future<Map<String, dynamic>> markAllAsRead() => _api.markAllAsRead();
}
