import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../calendar/controllers/calendar_controller.dart';

class TemplateJadwal {
  final String id;
  final String title;
  final String time;
  final String description;
  final RxBool isEnabled;

  TemplateJadwal({
    required this.id,
    required this.title,
    required this.time,
    required this.description,
    bool isEnabled = false,
  }) : isEnabled = isEnabled.obs;
}

class TemplateJadwalController extends GetxController {
  final templates = <TemplateJadwal>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTemplates();
  }

  void _loadTemplates() {
    templates.addAll([
      TemplateJadwal(
        id: '1',
        title: 'Cek Tensi Darah',
        time: '07:30',
        description: 'Pemeriksaan tensi darah pagi hari',
      ),
      TemplateJadwal(
        id: '2',
        title: 'Minum Obat Pagi',
        time: '08:00',
        description: 'Aspirin & Vitamin, sesudah makan',
        isEnabled: true,
      ),
      TemplateJadwal(
        id: '3',
        title: 'Latihan Fisik Ringan',
        time: '10:00',
        description: 'Peregangan sendi selama 15 menit',
      ),
      TemplateJadwal(
        id: '4',
        title: 'Makan Siang & Obat',
        time: '13:00',
        description: 'Makan siang dan obat penurun kolesterol',
      ),
    ]);
  }

  void saveTemplateSchedule() {
    try {
      final calendarController = Get.find<CalendarController>();
      for (var template in templates.where((t) => t.isEnabled.value)) {
        final timeParts = template.time.split(':');
        final now = DateTime.now();
        final scheduledAt = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );

        String scheduleType = 'daily_activity';
        if (template.title.toLowerCase().contains('obat')) {
          scheduleType = 'medication';
        } else if (template.title.toLowerCase().contains('tensi')) {
          scheduleType = 'routine_checkup';
        }

        calendarController.addSchedule({
          "title": template.title,
          "schedule_type": scheduleType,
          "scheduled_at": scheduledAt,
          "duration_minutes": 15,
        });
      }
    } catch (e) {
      debugPrint('CalendarController not found, running standalone');
    }

    Get.back();
    Get.snackbar(
      'Sukses',
      'Jadwal dari template berhasil ditambahkan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFBBF246),
      colorText: const Color(0xFF192126),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
