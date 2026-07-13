import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/schedule_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);

    return Scaffold(
      key: const Key('calendar_scaffold'),
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Jadwal Perawatan'),
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: () async => controller.refreshSchedules(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(pagePadding, 20, pagePadding, 112),
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildDateTabs(context),
              const SizedBox(height: 16),
              _buildAddScheduleButton(context),
              const SizedBox(height: 22),
              _buildScheduleSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final selected = controller.selectedDate;
      final count = controller.selectedDateSchedules.length;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_weekdayFull(selected)}, ${selected.day} ${_monthName(selected.month)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _dateHeaderStyle(context),
                ),
                const SizedBox(height: 4),
                Text(
                  count == 0
                      ? 'Belum ada kegiatan hari ini'
                      : '$count kegiatan terjadwal',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: count == 0 ? AppTheme.surfaceMuted : AppTheme.accentSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count kegiatan',
              style: textTheme.labelMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    });
  }

  TextStyle? _dateHeaderStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      color: AppTheme.textPrimary,
    );
  }

  Widget _buildDateTabs(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: controller.dateTabs.map((date) {
            return _buildDateChip(context, date);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDateChip(BuildContext context, DateTime date) {
    final selected = controller.isSelectedDate(date);
    final textTheme = Theme.of(context).textTheme;
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return Padding(
      key: Key('date_chip_${date.day}_${date.month}'),
      padding: const EdgeInsets.only(right: 8),
      child: Semantics(
        button: true,
        selected: selected,
        label: '${days[date.weekday - 1]} ${date.day}',
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => controller.selectDate(date),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: AppTheme.motion,
              curve: Curves.easeOutCubic,
              constraints: const BoxConstraints(minWidth: 58, minHeight: 66),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary : AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppTheme.primary : AppTheme.border,
                ),
                boxShadow: selected ? AppTheme.softShadow : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    days[date.weekday - 1],
                    style: textTheme.labelSmall?.copyWith(
                      color: selected
                          ? Colors.white.withValues(alpha: 0.72)
                          : AppTheme.textTertiary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: textTheme.titleMedium?.copyWith(
                      color: selected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddScheduleButton(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('add_schedule_button'),
      onPressed: _showCreateBottomSheet,
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text('Tambah Kegiatan'),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final schedules = controller.selectedDateSchedules;
      if (schedules.isEmpty) {
        return _buildEmptyScheduleState(context);
      }

      return Column(
        children: schedules
            .map((schedule) => _buildScheduleCard(context, schedule))
            .toList(),
      );
    });
  }

  Widget _buildEmptyScheduleState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      key: const Key('empty_schedule_state'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.accentSoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.calendar_month_rounded,
              color: AppTheme.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Belum ada kegiatan',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Tambahkan kegiatan manual, pilih template,\natau gunakan rekomendasi AI.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(color: AppTheme.textTertiary),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const Key('empty_add_schedule_button'),
            onPressed: _showCreateBottomSheet,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Tambah Kegiatan'),
          ),
        ],
      ),
    );
  }

  void _showCreateBottomSheet() {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.borderStrong,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Text('Tambah Kegiatan', style: Get.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                'Pilih cara paling cepat untuk membuat jadwal hari ini.',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
              const SizedBox(height: 20),
              _buildBottomSheetOption(
                icon: Icons.edit_calendar_outlined,
                title: 'Input Manual',
                subtitle: 'Masukkan detail kegiatan sendiri',
                onTap: () {
                  Get.back();
                  controller.navigateToAddSchedule();
                },
              ),
              const SizedBox(height: 10),
              _buildBottomSheetOption(
                icon: Icons.view_list_outlined,
                title: 'Pilih dari Template',
                subtitle: 'Gunakan template kegiatan rutin',
                onTap: () {
                  Get.back();
                  Get.toNamed(
                    Routes.TEMPLATE_JADWAL,
                    arguments: {'elderly_id': controller.elderlyId},
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildBottomSheetOption(
                icon: Icons.auto_awesome_outlined,
                title: 'Rekomendasi AI',
                subtitle: 'Saran berdasarkan riwayat kesehatan',
                iconColor: AppTheme.primary,
                iconBgColor: AppTheme.accent,
                onTap: () {
                  Get.back();
                  Get.toNamed(
                    Routes.REKOMENDASI_AI,
                    arguments: {'elderly_id': controller.elderlyId},
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = AppTheme.textPrimary,
    Color iconBgColor = AppTheme.surfaceMuted,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: AppTheme.cardDecoration(radius: 16, elevated: false),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, ScheduleModel schedule) {
    final textTheme = Theme.of(context).textTheme;
    final isCompleted = schedule.isCompleted;
    final time = schedule.scheduledAt;
    final typeStyle = _typeStyle(schedule.scheduleType);
    final hour12 = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    final timeString =
        '${hour12.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    final amPm = time.hour >= 12 ? 'PM' : 'AM';

    return AnimatedOpacity(
      key: ValueKey('schedule_card_${schedule.id}'),
      duration: AppTheme.motionFast,
      opacity: isCompleted ? 0.55 : 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: AppTheme.cardDecoration(
            radius: 18,
            elevated: !isCompleted,
            borderColor: isCompleted ? AppTheme.border : typeStyle.softColor,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: typeStyle.softColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(typeStyle.icon, color: typeStyle.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: isCompleted
                            ? AppTheme.textTertiary
                            : AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 13,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${schedule.durationMinutes ?? 0} menit',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    timeString,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    amPm,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: isCompleted
                    ? 'Tandai belum selesai'
                    : 'Tandai selesai',
                visualDensity: VisualDensity.compact,
                onPressed: () =>
                    controller.toggleScheduleCompletion(schedule.id),
                icon: Icon(
                  isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 22,
                  color: isCompleted ? AppTheme.success : AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ScheduleTypeStyle _typeStyle(String type) {
    switch (type) {
      case 'medication':
        return const _ScheduleTypeStyle(
          icon: Icons.medication_outlined,
          color: AppTheme.error,
          softColor: AppTheme.errorSoft,
        );
      case 'routine_checkup':
        return const _ScheduleTypeStyle(
          icon: Icons.health_and_safety_outlined,
          color: AppTheme.success,
          softColor: AppTheme.successSoft,
        );
      case 'daily_activity':
        return const _ScheduleTypeStyle(
          icon: Icons.directions_walk_rounded,
          color: AppTheme.warning,
          softColor: AppTheme.warningSoft,
        );
      default:
        return const _ScheduleTypeStyle(
          icon: Icons.event_rounded,
          color: AppTheme.primary,
          softColor: AppTheme.surfaceMuted,
        );
    }
  }

  String _weekdayFull(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[date.weekday - 1];
  }

  String _monthName(int month) {
    const months = [
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
    return months[month - 1];
  }
}

class _ScheduleTypeStyle {
  final IconData icon;
  final Color color;
  final Color softColor;

  const _ScheduleTypeStyle({
    required this.icon,
    required this.color,
    required this.softColor,
  });
}
