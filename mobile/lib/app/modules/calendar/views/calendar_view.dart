import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/schedule_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F8),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.80),
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F4), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'CareTrack',
          style: TextStyle(
            color: Color(0xFF1C1917),
            fontSize: 19,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.40,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFFFDF8F8)),
            child: Stack(
              children: [
                // --- Konten Utama ---
                Container(
                  width: double.infinity,
                  // Padding bottom disesuaikan
                  padding: const EdgeInsets.only(top: 24, bottom: 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 24,
                    children: [
                      _buildDateTabs(),
                      _buildAddScheduleButton(),
                      Obx(
                        () => Column(
                          children: controller.selectedDateSchedules
                              .map(
                                (schedule) =>
                                    _buildScheduleCard(schedule, controller),
                              )
                              .toList(),
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

  Widget _buildDateTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.dateTabs
                .map((date) => _buildDateChip(date))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDateChip(DateTime date) {
    final selected = controller.isSelectedDate(date);
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return GestureDetector(
      onTap: () => controller.selectDate(date),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        constraints: const BoxConstraints(minWidth: 64),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF192126) : const Color(0xFFBBF246),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF192126) : const Color(0x33C8C5CB),
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color(0x26000000)
                  : const Color(0x0CA1A1AA),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              days[date.weekday - 1],
              style: TextStyle(
                color: selected
                    ? Colors.white.withValues(alpha: 0.8)
                    : const Color(0xFF47464B),
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              date.day.toString(),
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF1C1B1C),
                fontSize: 20,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddScheduleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: _showCreateBottomSheet,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF192126),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                'Tambah Kegiatan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tambah Kegiatan',
              style: TextStyle(
                color: Color(0xFF1C1B1C),
                fontSize: 20,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih metode penambahan kegiatan untuk jadwal hari ini.',
              style: TextStyle(
                color: Color(0xFF77767B),
                fontSize: 14,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            _buildBottomSheetOption(
              icon: Icons.edit_calendar_outlined,
              title: 'Input Manual',
              subtitle: 'Masukkan detail kegiatan secara manual',
              onTap: () {
                Get.back(); // close bottom sheet
                controller.navigateToAddSchedule();
              },
            ),
            const SizedBox(height: 16),
            _buildBottomSheetOption(
              icon: Icons.view_list_outlined,
              title: 'Pilih dari Template',
              subtitle: 'Gunakan template kegiatan yang sering dipakai',
              onTap: () {
                Get.back();
                Get.toNamed(
                  Routes.TEMPLATE_JADWAL,
                  arguments: {'elderly_id': controller.elderlyId},
                );
              },
            ),
            const SizedBox(height: 16),
            _buildBottomSheetOption(
              icon: Icons.auto_awesome_outlined,
              title: 'Rekomendasi AI',
              subtitle: 'Dapatkan saran kegiatan berdasarkan riwayat',
              iconColor: const Color(0xFF192126),
              iconBgColor: const Color(0xFFBBF246),
              onTap: () {
                Get.back();
                Get.toNamed(
                  Routes.REKOMENDASI_AI,
                  arguments: {'elderly_id': controller.elderlyId},
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF1C1B1C),
    Color iconBgColor = const Color(0xFFF2F2F2),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1C1B1C),
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF77767B),
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFC8C5CB)),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(
    ScheduleModel schedule,
    CalendarController controller,
  ) {
    final isCompleted = schedule.isCompleted;
    final time = schedule.scheduledAt;
    final title = schedule.title;
    final type = schedule.scheduleType;

    IconData iconData = Icons.event;
    Color iconBgColor = const Color(0xFFE3E1EC);
    if (type == 'medication') {
      iconData = Icons.medication_outlined;
      iconBgColor = const Color(0xFFFFE6E6);
    } else if (type == 'routine_checkup') {
      iconData = Icons.health_and_safety_outlined;
      iconBgColor = const Color(0xFFE6F3E6);
    } else if (type == 'daily_activity') {
      iconData = Icons.directions_walk_outlined;
      iconBgColor = const Color(0xFFFFEBDD);
    }

    String timeString =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    String amPm = time.hour >= 12 ? "PM" : "AM";
    int hour12 = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    timeString =
        "${hour12.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

    Widget cardContent = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: ShapeDecoration(
        color: isCompleted
            ? Colors.white.withValues(alpha: 0.50)
            : Colors.white,
        shape: RoundedRectangleBorder(
          side: isCompleted
              ? const BorderSide(width: 1, color: Color(0x33C8C5CB))
              : BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: isCompleted
            ? []
            : const [
                BoxShadow(
                  color: Color(0x1EA1A1AA),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: ShapeDecoration(
              color: iconBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            child: Icon(iconData, color: const Color(0xFF1C1B1C), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: const Color(0xFF1C1B1C),
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                    letterSpacing: 0.14,
                  ),
                ),
                Text(
                  '${schedule.durationMinutes ?? 0} min',
                  style: const TextStyle(
                    color: Color(0xFF47464B),
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeString,
                textAlign: TextAlign.right,
                style: TextStyle(
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  color: const Color(0xFF1C1B1C),
                  fontSize: 14,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                  letterSpacing: 0.14,
                ),
              ),
              Text(
                amPm,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF47464B),
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => controller.toggleScheduleCompletion(schedule.id),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted ? const Color(0xFFBBF246) : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );

    return isCompleted
        ? Opacity(opacity: 0.60, child: cardContent)
        : cardContent;
  }
}
