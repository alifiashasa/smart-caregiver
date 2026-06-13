import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notification_repository.dart';

class NotifikasiController extends GetxController {
  final NotificationRepository _notificationRepository;

  NotifikasiController({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository;

  // ── Reactive state ──
  final _notifications = <NotificationModel>[].obs;
  final _isLoading = true.obs;
  final _unreadCount = 0.obs;
  final _totalCount = 0.obs;
  final _currentPage = 0.obs;
  final _hasMore = true.obs;
  final _isLoadingMore = false.obs;

  // ── Public getters ──
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading.value;
  int get unreadCount => _unreadCount.value;
  int get totalCount => _totalCount.value;
  int get currentPage => _currentPage.value;
  bool get hasMore => _hasMore.value;
  bool get isLoadingMore => _isLoadingMore.value;

  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      _currentPage.value = 0;
      _hasMore.value = true;
      _isLoading.value = true;
    }

    final result = await _notificationRepository.getNotificationItems(
      limit: _pageSize,
      offset: _currentPage.value * _pageSize,
    );

    result.when(
      success: (data) {
        _totalCount.value = data.total;

        if (refresh) {
          _notifications.assignAll(data.notifications);
        } else {
          _notifications.addAll(data.notifications);
        }

        _hasMore.value = _notifications.length < _totalCount.value;
      },
      failure: (_) {},
    );

    _isLoading.value = false;
    _isLoadingMore.value = false;
  }

  Future<void> fetchUnreadCount() async {
    final result = await _notificationRepository.getUnreadCount();

    if (!result['error'] && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      _unreadCount.value = data['unread_count'] as int? ?? 0;
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore.value || !_hasMore.value) return;

    _isLoadingMore.value = true;
    _currentPage.value++;
    await fetchNotifications();
  }

  Future<void> markAsRead(NotificationModel notification) async {
    final id = notification.id;
    if (id.isEmpty) return;

    final index = _notifications.indexWhere((item) => item.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _notifications.refresh();
      _unreadCount.value = (_unreadCount.value - 1).clamp(0, 999);
    }

    await _notificationRepository.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    final result = await _notificationRepository.markAllAsRead();
    if (!result['error']) {
      for (var i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
      _notifications.refresh();
      _unreadCount.value = 0;
      Get.snackbar(
        'Semua Dibaca',
        'Semua notifikasi telah ditandai sebagai dibaca',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFBBF246),
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  /// Human-readable notification type label
  static String typeLabel(String? type) {
    switch (type) {
      case 'health_recorded':
        return 'Data Kesehatan';
      case 'critical_alert':
        return 'Peringatan Kritis';
      case 'weekly_summary':
        return 'Ringkasan Mingguan';
      case 'alarm_reminder':
        return 'Pengingat';
      case 'activity_recommendation':
        return 'Rekomendasi AI';
      default:
        return 'Notifikasi';
    }
  }

  /// Human-readable relative time
  static String relativeTime(String? isoDate) {
    if (isoDate == null) return '';
    DateTime? dt;
    try {
      dt = DateTime.parse(isoDate);
    } catch (_) {
      return '';
    }
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m yang lalu';
    if (diff.inHours < 24) return '${diff.inHours}j yang lalu';
    if (diff.inDays < 7) return '${diff.inDays}h yang lalu';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }

  /// Check if notification is critical
  static bool isCritical(NotificationModel notification) {
    return notification.isCritical;
  }
}
