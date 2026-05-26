import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/schedule_api.dart';

class JadwalLansiaController extends GetxController {
  final ScheduleApi _api = ScheduleApi();

  // ── Form state ──
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedType = 'medication'.obs; // medication | routine_checkup | daily_activity
  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay.now().obs;
  final selectedRecurrence = 'NONE'.obs; // NONE | DAILY | WEEKLY | MONTHLY
  final alarmEnabled = true.obs;
  final reminderMinutes = 15.obs; // default 15 min before
  final isLoading = false.obs;
  final selectedTypeLabel = 'Medis'.obs;

  // ── Type options ──
  static const typeOptions = [
    {'value': 'medication', 'label': 'Medis', 'icon': Icons.medical_services},
    {'value': 'routine_checkup', 'label': 'Pemeriksaan', 'icon': Icons.assignment},
    {'value': 'daily_activity', 'label': 'Aktivitas', 'icon': Icons.directions_run},
  ];

  static const recurrenceOptions = [
    {'value': 'NONE', 'label': 'Sekali'},
    {'value': 'DAILY', 'label': 'Harian'},
    {'value': 'WEEKLY', 'label': 'Mingguan'},
    {'value': 'MONTHLY', 'label': 'Bulanan'},
  ];

  // ── Computed display ──
  String get dateDisplay {
    final d = selectedDate.value;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String get timeDisplay {
    final t = selectedTime.value;
    final hour = t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} $period';
  }

  String get recurrenceLabel {
    final r = selectedRecurrence.value;
    for (final opt in recurrenceOptions) {
      if (opt['value'] == r) return opt['label'] as String;
    }
    return 'Sekali';
  }

  // ── Actions ──
  void selectType(String value, String label) {
    selectedType.value = value;
    selectedTypeLabel.value = label;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void selectTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  void selectRecurrence(String value) {
    selectedRecurrence.value = value;
  }

  void toggleAlarm(bool enabled) {
    alarmEnabled.value = enabled;
  }

  int? get _elderlyId {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['elderly_id'] is int) return args['elderly_id'];
      return int.tryParse(args['elderly_id']?.toString() ?? '');
    }
    return null;
  }

  Future<void> saveSchedule() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Error', 'Nama aktivitas harus diisi');
      return;
    }

    final elderlyId = _elderlyId;
    if (elderlyId == null) {
      Get.snackbar('Error', 'Data lansia tidak ditemukan');
      return;
    }

    final t = selectedTime.value;
    final d = selectedDate.value;
    final scheduledAt = DateTime(
      d.year,
      d.month,
      d.day,
      t.hour,
      t.minute,
    );

    isLoading.value = true;

    final result = await _api.create(
      elderlyId: elderlyId,
      title: title,
      scheduleType: selectedType.value,
      scheduledAt: scheduledAt,
      description: descriptionController.text.trim().isNotEmpty
          ? descriptionController.text.trim()
          : null,
      durationMinutes: 30,
      recurrenceType: selectedRecurrence.value != 'NONE'
          ? selectedRecurrence.value
          : null,
      reminderMinutes: alarmEnabled.value ? [reminderMinutes.value] : [],
    );

    isLoading.value = false;

    if (result['error'] == true) {
      Get.snackbar('Error', result['message'] ?? 'Gagal menyimpan jadwal');
      return;
    }

    Get.back(result: true);
    Get.snackbar(
      'Sukses',
      'Jadwal berhasil ditambahkan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFBBF246),
      colorText: const Color(0xFF192126),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
