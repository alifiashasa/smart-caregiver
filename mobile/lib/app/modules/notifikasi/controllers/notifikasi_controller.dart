import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/notification_api.dart';

class NotifikasiController extends GetxController {
  final NotificationApi _api = NotificationApi();

  final notifications = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final unreadCount = 0.obs;
  final totalCount = 0.obs;
  final currentPage = 0.obs;
  final hasMore = true.obs;
  final isLoadingMore = false.obs;

  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
      isLoading.value = true;
    }

    final result = await _api.getNotifications(
      limit: _pageSize,
      offset: currentPage.value * _pageSize,
    );

    if (!result['error'] && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      final rawList = data['notifications'] as List<dynamic>? ?? [];
      totalCount.value = data['total'] as int? ?? 0;

      if (refresh) {
        notifications.assignAll(rawList.cast<Map<String, dynamic>>());
      } else {
        notifications.addAll(rawList.cast<Map<String, dynamic>>());
      }

      hasMore.value = notifications.length < totalCount.value;
    }

    isLoading.value = false;
    isLoadingMore.value = false;
  }

  Future<void> fetchUnreadCount() async {
    final result = await _api.getUnreadCount();

    if (!result['error'] && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      unreadCount.value = data['unread_count'] as int? ?? 0;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    await fetchNotifications();
  }

  Future<void> markAsRead(Map<String, dynamic> notification) async {
    final id = notification['id']?.toString();
    if (id == null || id.isEmpty) return;

    // Optimistic update
    final index = notifications.indexWhere((n) => n['id'] == id);
    if (index != -1 && notifications[index]['is_read'] == false) {
      notifications[index]['is_read'] = true;
      notifications.refresh();
      unreadCount.value = (unreadCount.value - 1).clamp(0, 999);
    }

    await _api.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    final result = await _api.markAllAsRead();
    if (!result['error']) {
      for (var i = 0; i < notifications.length; i++) {
        notifications[i]['is_read'] = true;
      }
      notifications.refresh();
      unreadCount.value = 0;
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

    // Format date like "12 Jan"
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }

  /// Check if notification is critical
  static bool isCritical(Map<String, dynamic> notification) {
    final type = notification['notification_type'] as String?;
    final priority = notification['priority'] as String?;
    return type == 'critical_alert' || priority == 'high';
  }
}
