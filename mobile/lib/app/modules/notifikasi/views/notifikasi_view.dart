import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/notification_model.dart';
import '../controllers/notifikasi_controller.dart';

class NotifikasiView extends GetView<NotifikasiController> {
  const NotifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundAlt,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundAlt,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Riwayat Notifikasi',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.primary,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.notifications.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () => controller.fetchNotifications(refresh: true),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 120) {
                  controller.loadMore();
                }
                return false;
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  AppTheme.pagePadding(context),
                  20,
                  AppTheme.pagePadding(context),
                  32,
                ),
                children: [
                  _buildIntro(context),
                  const SizedBox(height: 28),
                  ..._buildNotificationSections(context),
                  if (controller.hasMore || controller.isLoadingMore)
                    _buildLoadMoreIndicator(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(
      'Berikut notifikasi Anda dari beberapa hari terakhir.',
      style: textTheme.titleLarge?.copyWith(
        color: AppTheme.textTertiary,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
    );
  }

  List<Widget> _buildNotificationSections(BuildContext context) {
    final sections = <Widget>[];
    String? previousLabel;

    for (final notification in controller.notifications) {
      final label = _sectionLabel(notification.createdAt);
      if (label != previousLabel) {
        if (sections.isNotEmpty) sections.add(const SizedBox(height: 24));
        sections.add(_buildSectionHeader(context, label));
        sections.add(const SizedBox(height: 12));
        previousLabel = label;
      }

      sections.add(_buildNotificationCard(context, notification));
      sections.add(const SizedBox(height: 12));
    }

    return sections;
  }

  Widget _buildSectionHeader(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppTheme.textTertiary,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              size: 46,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada notifikasi',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Peringatan kesehatan, alarm, dan ringkasan mingguan akan muncul di sini.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel notification,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final isUnread = !notification.isRead;
    final time = _timeLabel(notification.createdAt);

    return Semantics(
      button: true,
      label:
          '${notification.title}. ${isUnread ? 'Belum dibaca' : 'Sudah dibaca'}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (isUnread) {
              controller.markAsRead(notification);
            }
          },
          child: Ink(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.035),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 44,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        _iconForType(notification.notificationType),
                        color: AppTheme.primary,
                        size: 28,
                      ),
                      if (isUnread)
                        Positioned(
                          top: -4,
                          right: 4,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              color: AppTheme.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppTheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                      if (notification.body.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          notification.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textTertiary,
                            height: 1.35,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        time,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textTertiary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _sectionLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDay = DateTime(date.year, date.month, date.day);
    final difference = today.difference(itemDay).inDays;

    if (difference == 0) return 'Hari ini';
    if (difference == 1) return 'Kemarin';
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  String _timeLabel(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _monthName(int month) {
    const names = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return names[month - 1];
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'critical_alert':
        return Icons.add_circle_outline_rounded;
      case 'alarm_reminder':
        return Icons.alarm_rounded;
      case 'weekly_summary':
        return Icons.article_outlined;
      case 'health_recorded':
        return Icons.monitor_heart_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }
}
