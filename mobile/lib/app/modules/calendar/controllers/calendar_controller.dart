import 'package:get/get.dart';
import '../../../core/logger.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../../../routes/app_pages.dart';

class CalendarController extends GetxController {
  final ScheduleRepository _scheduleRepository;

  CalendarController({required ScheduleRepository scheduleRepository})
      : _scheduleRepository = scheduleRepository;

  // ── Reactive state ──
  final _currentIndex = 1.obs;
  final _patientName = ''.obs;
  final _patientAge = ''.obs;
  final _patientImage = 'assets/images/patient_ibu_siti.png'.obs;
  final _patientGender = 'Perempuan'.obs;
  final _schedules = <Map<String, dynamic>>[].obs;
  final _isLoading = false.obs;
  final _elderlyId = ''.obs;

  // ── Public getters ──
  int get currentIndex => _currentIndex.value;
  String get patientName => _patientName.value;
  String get patientAge => _patientAge.value;
  String get patientImage => _patientImage.value;
  String get patientGender => _patientGender.value;
  List<Map<String, dynamic>> get schedules => _schedules;
  bool get isLoading => _isLoading.value;
  String get elderlyId => _elderlyId.value;

  set currentIndex(int value) => _currentIndex.value = value;

  @override
  void onInit() {
    super.onInit();
    _readArgs();
  }

  @override
  void onReady() {
    super.onReady();
    _loadSchedules();
    if (_currentIndex.value != 1) {
      Future.delayed(const Duration(milliseconds: 10), () {
        _currentIndex.value = 1;
      });
    }
  }

  void _readArgs() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['from'] != null) _currentIndex.value = args['from'] as int;
      if (args['name'] != null) _patientName.value = args['name'] as String;
      if (args['age'] != null) _patientAge.value = args['age'].toString();
      if (args['image'] != null) {
        _patientImage.value = args['image'] as String;
      }
      if (args['gender'] != null) {
        _patientGender.value = args['gender'] as String;
      }
      if (args['elderly_id'] != null) {
        _elderlyId.value = args['elderly_id'].toString();
      }
    }
    log.info('CalendarController._readArgs', data: {
      'elderly_id': _elderlyId.value,
      'has_args': Get.arguments != null,
    });
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
      scheduledAt = DateTime.parse(s['scheduled_at'] as String);
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
    if (result == true) {
      _loadSchedules();
    }
  }

  Future<void> toggleScheduleCompletion(String id) async {
    final result = await _scheduleRepository.markComplete(id);
    if (!result['error']) {
      final index = _schedules.indexWhere((s) => s['id'] == id);
      if (index != -1) {
        _schedules[index]['is_completed'] = true;
        _schedules.refresh();
      }
    }
  }

  void addSchedule(Map<String, dynamic> scheduleData) {
    scheduleData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    scheduleData['is_completed'] = false;
    _schedules.add(scheduleData);
    _schedules.sort(
      (a, b) => (a['scheduled_at'] as DateTime)
          .compareTo(b['scheduled_at'] as DateTime),
    );
  }

  void navigateToAddSchedule() async {
    final result = await Get.toNamed(
      Routes.JADWAL_LANSIA,
      arguments: {'elderly_id': _elderlyId.value},
    );
    if (result == true) {
      _loadSchedules();
    }
  }

  void changePage(int index) {
    if (_currentIndex.value == index) return;

    int previousIndex = _currentIndex.value;
    _currentIndex.value = index;

    final args = {
      'from': previousIndex,
      'name': _patientName.value,
      'age': _patientAge.value,
      'image': _patientImage.value,
      'gender': _patientGender.value,
      'elderly_id': _elderlyId.value,
    };

    if (index == 0) {
      Get.offNamed(Routes.DASHBOARD, arguments: args);
    } else if (index == 1) {
      Get.offNamed(Routes.CALENDAR, arguments: args);
    } else if (index == 2) {
      Get.offNamed(Routes.PATIENT_DETAIL, arguments: args);
    } else if (index == 3) {
      Get.offNamed(Routes.PROFIL_LANSIA, arguments: args);
    }
  }
}
