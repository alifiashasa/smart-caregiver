import 'package:get/get.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../../../routes/app_pages.dart';
import '../../patient_shell/controllers/patient_shell_controller.dart';

class CalendarController extends GetxController {
  final ScheduleRepository _scheduleRepository;
  final _shellWorkers = <Worker>[];

  CalendarController({required ScheduleRepository scheduleRepository})
    : _scheduleRepository = scheduleRepository;

  // ── Reactive state ──
  final _patientName = ''.obs;
  final _patientAge = ''.obs;
  final _patientImage = 'assets/images/patient_ibu_siti.png'.obs;
  final _patientGender = 'Perempuan'.obs;
  final _schedules = <Map<String, dynamic>>[].obs;
  final _selectedDate = DateTime.now().obs;
  final _isLoading = false.obs;
  final _elderlyId = ''.obs;

  // ── Public getters ──
  String get patientName => _patientName.value;
  String get patientAge => _patientAge.value;
  String get patientImage => _patientImage.value;
  String get patientGender => _patientGender.value;
  List<Map<String, dynamic>> get schedules => _schedules;
  List<Map<String, dynamic>> get selectedDateSchedules => _schedules
      .where(
        (schedule) =>
            _isSameDay(schedule['scheduled_at'] as DateTime, selectedDate),
      )
      .toList();
  DateTime get selectedDate => _selectedDate.value;
  List<DateTime> get dateTabs {
    final today = DateTime.now();
    final base = List.generate(
      7,
      (index) => DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(Duration(days: 3 - index)),
    );

    if (base.any((date) => _isSameDay(date, selectedDate))) {
      return base;
    }

    return [...base, selectedDate]..sort((a, b) => a.compareTo(b));
  }

  bool get isLoading => _isLoading.value;
  String get elderlyId => _elderlyId.value;

  void selectDate(DateTime date) {
    _selectedDate.value = DateTime(date.year, date.month, date.day);
  }

  bool isSelectedDate(DateTime date) => _isSameDay(date, selectedDate);

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void onInit() {
    super.onInit();
    final shell = Get.find<PatientShellController>();
    _readFromShell(shell);
    _bindShellProfile(shell);
  }

  void _readFromShell(PatientShellController shell) {
    _patientName.value = shell.patientName.value;
    _patientAge.value = shell.patientAge.value;
    _patientGender.value = shell.patientGender.value;
    _patientImage.value = shell.patientImage.value;
    _elderlyId.value = shell.elderlyId.value;
  }

  void _bindShellProfile(PatientShellController shell) {
    _shellWorkers.addAll([
      ever(shell.patientName, (value) => _patientName.value = value),
      ever(shell.patientAge, (value) => _patientAge.value = value),
      ever(shell.patientGender, (value) => _patientGender.value = value),
      ever(shell.patientImage, (value) => _patientImage.value = value),
    ]);
  }

  @override
  void onReady() {
    super.onReady();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    if (_elderlyId.value.isEmpty) return;

    _isLoading.value = true;

    final result = await _scheduleRepository.getSchedules(_elderlyId.value);

    if (!result['error'] && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      final rawList = data['schedules'] as List<dynamic>? ?? [];
      _schedules.value = rawList
          .map((s) => _normalizeSchedule(s as Map<String, dynamic>))
          .toList();
    }

    _isLoading.value = false;
  }

  Map<String, dynamic> _normalizeSchedule(Map<String, dynamic> s) {
    DateTime scheduledAt;
    try {
      scheduledAt = DateTime.parse(s['scheduled_at'] as String).toLocal();
    } catch (_) {
      scheduledAt = DateTime.now();
    }
    return {
      'id': s['id']?.toString() ?? '',
      'title': s['title'] ?? '',
      'schedule_type': s['schedule_type'] ?? '',
      'scheduled_at': scheduledAt,
      'duration_minutes': s['duration_minutes'],
      'is_completed': s['is_completed'] ?? false,
      'description': s['description'],
      'is_active': s['is_active'] ?? true,
      'alarms': s['alarms'] ?? [],
    };
  }

  void refreshSchedules() => _loadSchedules();

  void onScheduleCreated(dynamic result) {
    if (result is Map && result['created'] == true) {
      final rawSchedule = result['schedule'] ?? result['fallback'];
      if (rawSchedule is Map) {
        final normalized = _normalizeSchedule(
          Map<String, dynamic>.from(rawSchedule),
        );
        _upsertSchedule(normalized);
        selectDate(normalized['scheduled_at'] as DateTime);
      }
      _loadSchedules();
      return;
    }

    if (result == true) {
      _loadSchedules();
    }
  }

  void _upsertSchedule(Map<String, dynamic> schedule) {
    final index = _schedules.indexWhere((s) => s['id'] == schedule['id']);
    if (index == -1) {
      _schedules.add(schedule);
    } else {
      _schedules[index] = schedule;
    }
    _schedules.sort(
      (a, b) => (a['scheduled_at'] as DateTime).compareTo(
        b['scheduled_at'] as DateTime,
      ),
    );
    _schedules.refresh();
  }

  Future<void> toggleScheduleCompletion(String id) async {
    final index = _schedules.indexWhere((s) => s['id'] == id);
    if (index == -1) return;

    final previous = _schedules[index]['is_completed'] == true;
    final next = !previous;

    final optimistic = Map<String, dynamic>.from(_schedules[index]);
    optimistic['is_completed'] = next;
    _schedules[index] = optimistic;
    _schedules.refresh();

    final result = next
        ? await _scheduleRepository.markComplete(id)
        : await _scheduleRepository.markIncomplete(id);

    if (result['error'] == true) {
      final reverted = Map<String, dynamic>.from(_schedules[index]);
      reverted['is_completed'] = previous;
      _schedules[index] = reverted;
      _schedules.refresh();
      Get.snackbar(
        'Error',
        result['message'] ?? 'Gagal mengubah status jadwal',
      );
    }
  }

  void addSchedule(Map<String, dynamic> scheduleData) {
    scheduleData['id'] ??= DateTime.now().millisecondsSinceEpoch.toString();
    scheduleData['is_completed'] ??= false;
    _upsertSchedule(scheduleData);
  }

  void navigateToAddSchedule() async {
    final result = await Get.toNamed(
      Routes.JADWAL_LANSIA,
      arguments: {'elderly_id': _elderlyId.value},
    );
    onScheduleCreated(result);
  }

  @override
  void onClose() {
    for (final worker in _shellWorkers) {
      worker.dispose();
    }
    super.onClose();
  }
}
