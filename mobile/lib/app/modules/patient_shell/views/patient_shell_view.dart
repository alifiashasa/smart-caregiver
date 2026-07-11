import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../calendar/views/calendar_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../patient_detail/views/patient_detail_view.dart';
import '../../profil-lansia/views/profil_lansia_view.dart';
import '../controllers/patient_shell_controller.dart';

class PatientShellView extends GetView<PatientShellController> {
  final int initialTab;

  const PatientShellView({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    controller.applyInitialTab(initialTab);

    return Scaffold(
      extendBody: true,
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
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.18),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Obx(
            () => Row(
              children: [
                _buildNavItem(0, Icons.dashboard_rounded, 'Home', key: const Key('nav_home')),
                _buildNavItem(1, Icons.calendar_today_rounded, 'Jadwal', key: const Key('nav_jadwal')),
                _buildNavItem(2, Icons.monitor_heart_rounded, 'Riwayat', key: const Key('nav_riwayat')),
                _buildNavItem(3, Icons.person_rounded, 'Profil', key: const Key('nav_profil')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {Key? key}) {
    final isSelected = controller.currentIndex == index;

    return Expanded(
      key: key,
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          child: InkWell(
            onTap: () => controller.changeTab(index),
            borderRadius: BorderRadius.circular(26),
            child: AnimatedContainer(
              duration: AppTheme.motion,
              curve: Curves.easeOutCubic,
              constraints: const BoxConstraints(minHeight: 52),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: isSelected
                        ? AppTheme.primary
                        : Colors.white.withValues(alpha: 0.72),
                    size: 21,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.primary
                          : Colors.white.withValues(alpha: 0.72),
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      letterSpacing: -0.1,
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
}
