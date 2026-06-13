import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_shell_controller.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../calendar/views/calendar_view.dart';
import '../../patient_detail/views/patient_detail_view.dart';
import '../../profil-lansia/views/profil_lansia_view.dart';

class PatientShellView extends GetView<PatientShellController> {
  final int initialTab;

  const PatientShellView({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    controller.applyInitialTab(initialTab);

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex,
          children: const [
            DashboardView(),
            CalendarView(),
            PatientDetailView(),
            ProfilLansiaView(),
          ],
        ),
      ),
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
                _buildNavItem(0, Icons.home_filled, 'Home'),
                _buildNavItem(1, Icons.calendar_today_outlined, 'Calendar'),
                _buildNavItem(2, Icons.medical_services_outlined, 'Riwayat'),
                _buildNavItem(3, Icons.person_outline, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = controller.currentIndex == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
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
}
