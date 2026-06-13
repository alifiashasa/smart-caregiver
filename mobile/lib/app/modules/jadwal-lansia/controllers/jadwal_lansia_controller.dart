import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/schedule_repository.dart';

class JadwalLansiaController extends GetxController {
  final ScheduleRepository _scheduleRepository;

  JadwalLansiaController({required ScheduleRepository scheduleRepository})
    : _scheduleRepository = scheduleRepository;

  // ── Form controllers ──
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // ── Reactive state ──
  final _selectedType = 'medication'.obs;
  final _selectedDate = DateTime.now().obs;
  final _selectedTime = TimeOfDay.now().obs;
  final _selectedRecurrence = 'NONE'.obs;
  final _alarmEnabled = true.obs;
  final _reminderMinutes = 15.obs;
  final _isLoading = false.obs;
  final _selectedTypeLabel = 'Medis'.obs;

  // ── Public getters ──
  String get selectedType => _selectedType.value;
  DateTime get selectedDate => _selectedDate.value;
  TimeOfDay get selectedTime => _selectedTime.value;
  String get selectedRecurrence => _selectedRecurrence.value;
  bool get alarmEnabled => _alarmEnabled.value;
  int get reminderMinutes => _reminderMinutes.value;
  bool get isLoading => _isLoading.value;
  String get selectedTypeLabel => _selectedTypeLabel.value;

  // ── Type options ──
  static const typeOptions = [
    {'value': 'medication', 'label': 'Medis', 'icon': Icons.medical_services},
    {
      'value': 'routine_checkup',
      'label': 'Pemeriksaan',
      'icon': Icons.assignment,
    },
    {
      'value': 'daily_activity',
      'label': 'Aktivitas',
      'icon': Icons.directions_run,
    },
  ];

  static const recurrenceOptions = [
    {'value': 'NONE', 'label': 'Sekali'},
    {'value': 'DAILY', 'label': 'Harian'},
    {'value': 'WEEKLY', 'label': 'Mingguan'},
    {'value': 'MONTHLY', 'label': 'Bulanan'},
  ];

  // ── Computed display ──
  String get dateDisplay {
    final d = _selectedDate.value;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String get timeDisplay {
    final t = _selectedTime.value;
    final hour = t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} $period';
  }

  String get recurrenceLabel {
    final r = _selectedRecurrence.value;
    for (final opt in recurrenceOptions) {
      if (opt['value'] == r) return opt['label'] as String;
    }
    return 'Sekali';
  }

  // ── Actions ──
  void selectType(String value, String label) {
    _selectedType.value = value;
    _selectedTypeLabel.value = label;
  }

  void selectDate(DateTime date) => _selectedDate.value = date;
  void selectTime(TimeOfDay time) => _selectedTime.value = time;
  void selectRecurrence(String value) => _selectedRecurrence.value = value;
  void toggleAlarm(bool enabled) => _alarmEnabled.value = enabled;

  String? get _elderlyId {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      final id = args['elderly_id']?.toString();
      return (id != null && id.isNotEmpty) ? id : null;
    }
    return null;
  }

  Future<void> saveSchedule() async {
    if (_isLoading.value) return;

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

    final t = _selectedTime.value;
    final d = _selectedDate.value;
    final scheduledAt = DateTime(d.year, d.month, d.day, t.hour, t.minute);

    _isLoading.value = true;

    final result = await _scheduleRepository.create(
      elderlyId: elderlyId,
      title: title,
      scheduleType: _selectedType.value,
      scheduledAt: scheduledAt,
      description: descriptionController.text.trim().isNotEmpty
          ? descriptionController.text.trim()
          : null,
      durationMinutes: 30,
      recurrenceType: _selectedRecurrence.value != 'NONE'
          ? _selectedRecurrence.value
          : null,
      reminderMinutes: _alarmEnabled.value ? [_reminderMinutes.value] : [],
    );

    _isLoading.value = false;

    if (result['error'] == true) {
      Get.snackbar('Error', result['message'] ?? 'Gagal menyimpan jadwal');
      return;
    }

    Get.back(
      result: {
        'created': true,
        'schedule': result['data'],
        'fallback': {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': title,
          'schedule_type': _selectedType.value,
          'scheduled_at': scheduledAt.toIso8601String(),
          'duration_minutes': 30,
          'is_completed': false,
          'description': descriptionController.text.trim().isNotEmpty
              ? descriptionController.text.trim()
              : null,
          'is_active': true,
          'alarms': [],
        },
      },
    );
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
