import 'package:get/get.dart';
import '../../../data/models/schedule_model.dart';
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
  final _schedules = <ScheduleModel>[].obs;
  final _selectedDate = DateTime.now().obs;
  final _isLoading = false.obs;
  final _elderlyId = ''.obs;

  // ── Public getters ──
  String get patientName => _patientName.value;
  String get patientAge => _patientAge.value;
  String get patientImage => _patientImage.value;
  String get patientGender => _patientGender.value;
  List<ScheduleModel> get schedules => _schedules;
  List<ScheduleModel> get selectedDateSchedules => _schedules
      .where((schedule) => _isSameDay(schedule.scheduledAt, selectedDate))
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

    final result = await _scheduleRepository.getScheduleItems(_elderlyId.value);

    result.when(
      success: (schedules) => _schedules.value = schedules,
      failure: (failure) {
        if (failure.sessionExpired) {
          Get.offAllNamed(Routes.LOGIN);
        }
      },
    );

    _isLoading.value = false;
  }

  void refreshSchedules() => _loadSchedules();

  void onScheduleCreated(dynamic result) {
    if (result is Map && result['created'] == true) {
      final rawSchedule = result['schedule'] ?? result['fallback'];
      if (rawSchedule is Map) {
        final normalized = ScheduleModel.fromJson(
          Map<String, dynamic>.from(rawSchedule),
        );
        _upsertSchedule(normalized);
        selectDate(normalized.scheduledAt);
      }
      _loadSchedules();
      return;
    }

    if (result == true) {
      _loadSchedules();
    }
  }

  void _upsertSchedule(ScheduleModel schedule) {
    final index = _schedules.indexWhere((s) => s.id == schedule.id);
    if (index == -1) {
      _schedules.add(schedule);
    } else {
      _schedules[index] = schedule;
    }
    _schedules.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    _schedules.refresh();
  }

  Future<void> toggleScheduleCompletion(String id) async {
    final index = _schedules.indexWhere((s) => s.id == id);
    if (index == -1) return;

    final previous = _schedules[index].isCompleted;
    final next = !previous;

    _schedules[index] = _schedules[index].copyWith(isCompleted: next);
    _schedules.refresh();

    final result = next
        ? await _scheduleRepository.markComplete(id)
        : await _scheduleRepository.markIncomplete(id);

    if (result['error'] == true) {
      _schedules[index] = _schedules[index].copyWith(isCompleted: previous);
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
    _upsertSchedule(ScheduleModel.fromJson(scheduleData));
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
