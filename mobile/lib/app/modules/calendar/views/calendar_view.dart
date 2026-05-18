import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minWidth: 64,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                          left: 16.89,
                                          right: 16.91,
                                          bottom: 12,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFBBF246),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 1,
                                              color: Color(0x33C8C5CB),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          shadows: const [
                                            BoxShadow(
                                              color: Color(0x0CA1A1AA),
                                              blurRadius: 16,
                                              offset: Offset(0, 4),
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 28.20,
                                                  height: 16,
                                                  child: Text(
                                                    'WED',
                                                    style: TextStyle(
                                                      color: Color(0xFF47464B),
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.33,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 24.19,
                                                  height: 28,
                                                  child: Text(
                                                    '23',
                                                    style: TextStyle(
                                                      color: Color(0xFF1C1B1C),
                                                      fontSize: 20,
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.40,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minWidth: 64,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                          left: 19.66,
                                          right: 19.65,
                                          bottom: 12,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          shadows: const [
                                            BoxShadow(
                                              color: Color(0x26000000),
                                              blurRadius: 16,
                                              offset: Offset(0, 4),
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 23.75,
                                                  height: 16,
                                                  child: Text(
                                                    'THU',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.80,
                                                          ),
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.33,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 24.69,
                                                  height: 28,
                                                  child: Text(
                                                    '24',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.40,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minWidth: 64,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                          left: 18.86,
                                          right: 18.87,
                                          bottom: 12,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFBBF246),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 1,
                                              color: Color(0x33C8C5CB),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          shadows: const [
                                            BoxShadow(
                                              color: Color(0x0CA1A1AA),
                                              blurRadius: 16,
                                              offset: Offset(0, 4),
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 18.13,
                                                  height: 16,
                                                  child: Text(
                                                    'FRI',
                                                    style: TextStyle(
                                                      color: Color(0xFF47464B),
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.33,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 24.27,
                                                  height: 28,
                                                  child: Text(
                                                    '25',
                                                    style: TextStyle(
                                                      color: Color(0xFF1C1B1C),
                                                      fontSize: 20,
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.40,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minWidth: 64,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                          left: 19,
                                          right: 19.02,
                                          bottom: 12,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFBBF246),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 1,
                                              color: Color(0x33C8C5CB),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          shadows: const [
                                            BoxShadow(
                                              color: Color(0x0CA1A1AA),
                                              blurRadius: 16,
                                              offset: Offset(0, 4),
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 21.80,
                                                  height: 16,
                                                  child: Text(
                                                    'SAT',
                                                    style: TextStyle(
                                                      color: Color(0xFF47464B),
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.33,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 23.98,
                                                  height: 28,
                                                  child: Text(
                                                    '26',
                                                    style: TextStyle(
                                                      color: Color(0xFF1C1B1C),
                                                      fontSize: 20,
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.40,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minWidth: 64,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                          left: 18.41,
                                          right: 18.40,
                                          bottom: 12,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFBBF246),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 1,
                                              color: Color(0x33C8C5CB),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          shadows: const [
                                            BoxShadow(
                                              color: Color(0x0CA1A1AA),
                                              blurRadius: 16,
                                              offset: Offset(0, 4),
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 25.19,
                                                  height: 16,
                                                  child: Text(
                                                    'SUN',
                                                    style: TextStyle(
                                                      color: Color(0xFF47464B),
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.33,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 23.05,
                                                  height: 28,
                                                  child: Text(
                                                    '27',
                                                    style: TextStyle(
                                                      color: Color(0xFF1C1B1C),
                                                      fontSize: 20,
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.40,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Column(
                          children: controller.mockSchedules
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
      // Floating Action Button (+)
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 25,
              offset: Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: IconButton(
          onPressed: _showCreateBottomSheet,
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Custom Bottom Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: ShapeDecoration(
            color: const Color(0xFF192126),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_filled, "Home"),
                _buildNavItem(1, Icons.calendar_today_outlined, "Calendar"),
                _buildNavItem(2, Icons.medical_services_outlined, "medical"),
                _buildNavItem(3, Icons.person_outline, "Person"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFBBF246) : Colors.transparent,
          borderRadius: BorderRadius.circular(43),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF192126) : Colors.white70,
              size: 24,
            ),
            if (isSelected && label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF192126),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Lato',
                  fontSize: 13,
                ),
              ),
            ],
          ],
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
                Get.toNamed(Routes.JADWAL_LANSIA);
              },
            ),
            const SizedBox(height: 16),
            _buildBottomSheetOption(
              icon: Icons.view_list_outlined,
              title: 'Pilih dari Template',
              subtitle: 'Gunakan template kegiatan yang sering dipakai',
              onTap: () {
                Get.back();
                Get.toNamed(Routes.TEMPLATE_JADWAL);
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
                Get.toNamed(Routes.REKOMENDASI_AI);
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
    Map<String, dynamic> schedule,
    CalendarController controller,
  ) {
    bool isCompleted = schedule['is_completed'];
    DateTime time = schedule['scheduled_at'];
    String title = schedule['title'];
    String type = schedule['schedule_type'];

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
                  '${schedule['duration_minutes']} min',
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
          if (isCompleted) ...[
            const SizedBox(width: 16),
            const Icon(Icons.check_circle, color: Color(0xFFBBF246)),
          ],
          if (!isCompleted) ...[
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => controller.toggleScheduleCompletion(schedule['id']),
              child: const Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );

    return isCompleted
        ? Opacity(opacity: 0.60, child: cardContent)
        : cardContent;
  }
}
