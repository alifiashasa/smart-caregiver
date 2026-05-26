import 'package:get/get.dart';
import '../../../data/schedule_api.dart';
import '../../../routes/app_pages.dart';

class CalendarController extends GetxController {
  final ScheduleApi _api = ScheduleApi();

  final currentIndex = 1.obs;

  // ── Patient data (from args) ──
  final patientName = ''.obs;
  final patientAge = ''.obs;
  final patientImage = 'assets/images/patient_ibu_siti.png'.obs;
  final patientGender = 'Perempuan'.obs;

  // ── Schedules from API ──
  final schedules = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final elderlyId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _readArgs();
  }

  @override
  void onReady() {
    super.onReady();
    _loadSchedules();
    if (currentIndex.value != 1) {
      Future.delayed(const Duration(milliseconds: 10), () {
        currentIndex.value = 1;
      });
    }
  }

  void _readArgs() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['from'] != null) currentIndex.value = args['from'] as int;
      if (args['name'] != null) patientName.value = args['name'] as String;
      if (args['age'] != null) patientAge.value = args['age'] as String;
      if (args['image'] != null) patientImage.value = args['image'] as String;
      if (args['gender'] != null) {
        patientGender.value = args['gender'] as String;
      }
      if (args['elderly_id'] is int) {
        elderlyId.value = args['elderly_id'];
      } else if (args['elderly_id'] != null) {
        elderlyId.value =
            int.tryParse(args['elderly_id'].toString()) ?? 0;
      }
    }
  }

  Future<void> _loadSchedules() async {
    if (elderlyId.value <= 0) return;

    isLoading.value = true;

    final result = await _api.getSchedules(elderlyId.value);

    if (!result['error'] && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      final rawList = data['schedules'] as List<dynamic>? ?? [];
      schedules.value = rawList
          .map((s) => _normalizeSchedule(s as Map<String, dynamic>))
          .toList();
    }

    isLoading.value = false;
  }

  Map<String, dynamic> _normalizeSchedule(Map<String, dynamic> s) {
    // Parse ISO datetime string to DateTime object for display
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

  void refreshSchedules() {
    _loadSchedules();
  }

  /// Called after jadwal-lansia screen creates a schedule
  void onScheduleCreated(dynamic result) {
    if (result == true) {
      _loadSchedules();
    }
  }

  Future<void> toggleScheduleCompletion(String id) async {
    final result = await _api.markComplete(id);
    if (!result['error']) {
      final index = schedules.indexWhere((s) => s['id'] == id);
      if (index != -1) {
        schedules[index]['is_completed'] = true;
        schedules.refresh();
      }
    }
  }

  void addSchedule(Map<String, dynamic> scheduleData) {
    // Navigate to jadwal-lansia form with elderly data
    scheduleData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    scheduleData['is_completed'] = false;
    schedules.add(scheduleData);

    schedules.sort(
      (a, b) => (a['scheduled_at'] as DateTime)
          .compareTo(b['scheduled_at'] as DateTime),
    );
  }

  void navigateToAddSchedule() async {
    final result = await Get.toNamed(
      Routes.JADWAL_LANSIA,
      arguments: {'elderly_id': elderlyId.value},
    );
    if (result == true) {
      _loadSchedules();
    }
  }

  void changePage(int index) {
    if (currentIndex.value == index) return;

    int previousIndex = currentIndex.value;
    currentIndex.value = index;

    final args = {
      'from': previousIndex,
      'name': patientName.value,
      'age': patientAge.value,
      'image': patientImage.value,
      'gender': patientGender.value,
      'elderly_id': elderlyId.value,
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