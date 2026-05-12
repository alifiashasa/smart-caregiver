import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../calendar/controllers/calendar_controller.dart';

class RekomendasiAiController extends GetxController {
  final recommendations = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchRecommendations();
  }

  void _fetchRecommendations() async {
    isLoading.value = true;
    // Simulate AI loading
    await Future.delayed(const Duration(seconds: 2));

    recommendations.assignAll([
      {
        'title': 'Jalan Santai Pagi',
        'type': 'Fisik',
        'duration': '15 Menit',
        'reason':
            'Kadar gula darah sedikit tinggi kemarin, aktivitas fisik ringan pagi hari dapat membantu menstabilkan.',
      },
      {
        'title': 'Meditasi / Relaksasi',
        'type': 'Mental',
        'duration': '10 Menit',
        'reason':
            'Tensi agak fluktuatif, latihan pernapasan akan membantu menurunkan stres dan tekanan darah.',
      },
      {
        'title': 'Perbanyak Minum Air',
        'type': 'Hidrasi',
        'duration': 'Sepanjang Hari',
        'reason':
            'Cuaca hari ini cukup panas, pastikan lansia mendapat asupan cairan minimal 1.5 liter.',
      },
    ]);

    isLoading.value = false;
  }

  void approveRecommendation(Map<String, dynamic> rec) {
    try {
      final calendarController = Get.find<CalendarController>();
      final now = DateTime.now();
      calendarController.addSchedule({
        "title": rec['title'],
        "schedule_type": "daily_activity",
        "scheduled_at": now.add(
          const Duration(hours: 1),
        ), // Mocking adding it for 1 hour later
        "duration_minutes": 15,
      });
    } catch (e) {
      debugPrint('CalendarController not found');
    }

    Get.snackbar(
      'Ditambahkan',
      '${rec['title']} berhasil ditambahkan ke jadwal',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFBBF246),
      colorText: const Color(0xFF192126),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
