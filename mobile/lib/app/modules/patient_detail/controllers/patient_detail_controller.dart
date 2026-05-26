import 'package:get/get.dart';
import '../../../data/elderly_api.dart';
import '../../../data/health_api.dart';
import '../../../routes/app_pages.dart';

class PatientDetailController extends GetxController {
  final patientName = ''.obs;
  final patientAge = ''.obs;
  final patientGender = ''.obs;
  final patientPhotoUrl = ''.obs;
  final patientMobilityLevel = ''.obs;
  final patientMedicalHistory = ''.obs;
  final patientPhysicalCondition = ''.obs;
  final patientHobbiesInterests = ''.obs;
  final patientStatus = ''.obs;
  final isLoading = false.obs;

  int? elderlyId;

  final records = <Map<String, dynamic>>[].obs;
  final isLoadingRecords = false.obs;

  final currentIndex = 2.obs;

  final ElderlyApi _elderlyApi = ElderlyApi();
  final HealthApi _healthApi = HealthApi();

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      elderlyId = args['elderly_id'] is int
          ? args['elderly_id']
          : int.tryParse(args['elderly_id']?.toString() ?? '');

      if (args['from'] != null) {
        currentIndex.value = args['from'];
      }

      patientName.value = args['name'] ?? '';
      if (patientName.value.isNotEmpty) {
        patientGender.value = args['gender'] ?? '';
        patientPhotoUrl.value = args['image'] ?? '';
      }
    }

    if (elderlyId != null) {
      loadDetail(elderlyId!);
      loadHealthRecords(elderlyId!);
    }
  }

  Future<void> loadDetail(int id) async {
    isLoading.value = true;

    final result = await _elderlyApi.getById(id);

    isLoading.value = false;

    if (result['error'] == true) {
      patientName.value = patientName.value.isNotEmpty
          ? patientName.value
          : 'Budi Santoso';
      return;
    }

    final data = result['data'] as Map<String, dynamic>?;
    if (data != null) {
      patientName.value = data['full_name'] ?? patientName.value;
      patientAge.value = data['age']?.toString() ?? '';
      patientGender.value = data['gender'] ?? '';
      patientPhotoUrl.value = data['photo_url'] ?? '';
      patientMobilityLevel.value = data['mobility_level'] ?? '';
      patientMedicalHistory.value = data['medical_history'] ?? '';
      patientPhysicalCondition.value = data['physical_condition'] ?? '';
      patientHobbiesInterests.value = data['hobbies_interests'] ?? '';
      patientStatus.value = data['status'] ?? '';
    }
  }

  Future<void> loadHealthRecords(int id) async {
    isLoadingRecords.value = true;

    final result = await _healthApi.getRecords(id);

    isLoadingRecords.value = false;

    if (result['error'] == true || result['data'] == null) return;

    final data = result['data'] as Map<String, dynamic>;
    final rawList = data['records'] as List<dynamic>?;
    if (rawList == null || rawList.isEmpty) return;

    records.assignAll(
      rawList.cast<Map<String, dynamic>>().map(_normalizeRecord),
    );
  }

  /// Map server HealthRecordResponse → TimelineCard-compatible fields
  Map<String, dynamic> _normalizeRecord(Map<String, dynamic> rec) {
    final isCritical = _isStatusCritical(rec['health_status'] as String?);

    // Format date
    String dateStr;
    try {
      final dt = DateTime.parse(rec['recorded_at'] as String);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ];
      dateStr = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      dateStr = rec['recorded_at'] as String? ?? '';
    }

    // Tensi
    final sys = _fmtNum(rec['systolic_bp']);
    final dia = _fmtNum(rec['diastolic_bp']);
    final tensi = sys != null && dia != null ? '$sys/$dia' : '—';

    // Suhu
    final suhu = _fmtNum(rec['body_temperature']);
    final suhuDisplay = suhu != null ? '$suhu°C' : '—';

    // Notes
    final notes = _buildNotes(rec);

    // Symptoms from complaints
    final symptoms = <String>[];
    if (rec['complaints'] != null) {
      final rawComplaints = rec['complaints'].toString();
      if (rawComplaints.isNotEmpty) {
        symptoms.add(rawComplaints);
      }
    }

    // Fuzzy analysis details
    final fuzzy = rec['fuzzy_analysis'] as Map<String, dynamic>?;
    if (fuzzy != null) {
      final finalStatus = fuzzy['final_status'] as String?;
      final finalScore = fuzzy['final_score'];
      if (finalStatus != null && finalScore != null) {
        symptoms.add('Skor: $finalStatus ($finalScore)');
      }
    }

    final statusLabel = _statusLabel(rec['health_status'] as String?);

    return {
      'date': dateStr,
      'status': statusLabel,
      'tensi': tensi,
      'suhu': suhuDisplay,
      'notes': notes,
      'symptoms': symptoms,
      'color': isCritical ? 0xFFE2E2E2 : 0xFFBBF246,
      'textColor': isCritical ? 0xFF192126 : 0xFF1C1B1C,
    };
  }

  String _buildNotes(Map<String, dynamic> rec) {
    final parts = <String>[];
    if (rec['daily_notes'] != null) {
      final notes = rec['daily_notes'].toString().trim();
      if (notes.isNotEmpty) parts.add(notes);
    }

    final fuzzy = rec['fuzzy_analysis'] as Map<String, dynamic>?;
    if (fuzzy != null) {
      for (final module in ['cardiovascular', 'metabolic', 'infection']) {
        final m = fuzzy[module] as Map<String, dynamic>?;
        if (m != null) {
          final status = m['status'] as String?;
          final score = m['score'];
          if (status != null && score != null) {
            parts.add('$module: $status ($score)');
          }
        }
      }
    }

    return parts.join('\n');
  }

  bool _isStatusCritical(String? status) {
    return status == 'needs_attention' || status == 'critical' || status == 'warning';
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'normal':
        return 'Normal';
      case 'warning':
        return 'Waspada';
      case 'needs_attention':
        return 'Perlu Perhatian';
      case 'critical':
        return 'Kritis';
      default:
        return 'Normal';
    }
  }

  String? _fmtNum(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toString();
    if (value is double) {
      if (value == value.roundToDouble()) return value.toInt().toString();
      return value.toStringAsFixed(1);
    }
    return value.toString();
  }

  void changePage(int index) {
    if (currentIndex.value == index) return;

    int previousIndex = currentIndex.value;
    currentIndex.value = index;

    if (index == 0) {
      Get.offNamed(Routes.DASHBOARD, arguments: {'from': previousIndex});
    } else if (index == 1) {
      Get.offNamed(Routes.CALENDAR, arguments: {'from': previousIndex});
    } else if (index == 2) {
      Get.offNamed(Routes.PATIENT_DETAIL, arguments: {'from': previousIndex});
    } else if (index == 3) {
      Get.offNamed(Routes.PROFIL_LANSIA, arguments: {'from': previousIndex});
    }
  }
}