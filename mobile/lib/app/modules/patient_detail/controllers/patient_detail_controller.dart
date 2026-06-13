import 'package:get/get.dart';
import '../../../data/repositories/elderly_repository.dart';
import '../../../data/repositories/health_repository.dart';
import '../../patient_shell/controllers/patient_shell_controller.dart';

class PatientDetailController extends GetxController {
  final ElderlyRepository _elderlyRepository;
  final HealthRepository _healthRepository;
  final _shellWorkers = <Worker>[];

  PatientDetailController({
    required ElderlyRepository elderlyRepository,
    required HealthRepository healthRepository,
  }) : _elderlyRepository = elderlyRepository,
       _healthRepository = healthRepository;

  // ── Reactive state ──
  final _patientName = ''.obs;
  final _patientAge = ''.obs;
  final _patientGender = ''.obs;
  final _patientPhotoUrl = ''.obs;
  final _patientMobilityLevel = ''.obs;
  final _patientMedicalHistory = ''.obs;
  final _patientPhysicalCondition = ''.obs;
  final _patientHobbiesInterests = ''.obs;
  final _patientStatus = ''.obs;
  final _isLoading = false.obs;
  final _records = <Map<String, dynamic>>[].obs;
  final _isLoadingRecords = false.obs;

  // ── Public getters ──
  String get patientName => _patientName.value;
  String get patientAge => _patientAge.value;
  String get patientGender => _patientGender.value;
  String get patientPhotoUrl => _patientPhotoUrl.value;
  String get patientMobilityLevel => _patientMobilityLevel.value;
  String get patientMedicalHistory => _patientMedicalHistory.value;
  String get patientPhysicalCondition => _patientPhysicalCondition.value;
  String get patientHobbiesInterests => _patientHobbiesInterests.value;
  String get patientStatus => _patientStatus.value;
  bool get isLoading => _isLoading.value;
  List<Map<String, dynamic>> get records => _records;
  bool get isLoadingRecords => _isLoadingRecords.value;

  String? _elderlyId;
  String? get elderlyId => _elderlyId;

  @override
  void onInit() {
    super.onInit();

    final shell = Get.find<PatientShellController>();
    _readFromShell(shell);
    _bindShellProfile(shell);

    if (_elderlyId != null && _elderlyId!.isNotEmpty) {
      loadDetail(_elderlyId!);
      loadHealthRecords(_elderlyId!);
    }
  }

  void _readFromShell(PatientShellController shell) {
    _elderlyId = shell.elderlyId.value.isNotEmpty
        ? shell.elderlyId.value
        : null;
    _patientName.value = shell.patientName.value;
    _patientAge.value = shell.patientAge.value.replaceAll(' Tahun', '');
    _patientGender.value = shell.patientGender.value;
    _patientPhotoUrl.value = shell.patientImage.value;
  }

  void _bindShellProfile(PatientShellController shell) {
    _shellWorkers.addAll([
      ever(shell.patientName, (value) => _patientName.value = value),
      ever(
        shell.patientAge,
        (value) => _patientAge.value = value.replaceAll(' Tahun', ''),
      ),
      ever(shell.patientGender, (value) => _patientGender.value = value),
      ever(shell.patientImage, (value) => _patientPhotoUrl.value = value),
    ]);
  }

  Future<void> loadDetail(String id) async {
    _isLoading.value = true;

    final result = await _elderlyRepository.getById(id);

    _isLoading.value = false;

    if (result['error'] == true) {
      _patientName.value = _patientName.value.isNotEmpty
          ? _patientName.value
          : 'Budi Santoso';
      return;
    }

    final data = result['data'] as Map<String, dynamic>?;
    if (data != null) {
      _patientName.value = data['full_name'] ?? _patientName.value;
      _patientAge.value = data['age']?.toString() ?? '';
      _patientGender.value = data['gender'] ?? '';
      _patientPhotoUrl.value = data['photo_url'] ?? '';
      _patientMobilityLevel.value = data['mobility_level'] ?? '';
      _patientMedicalHistory.value = data['medical_history'] ?? '';
      _patientPhysicalCondition.value = data['physical_condition'] ?? '';
      _patientHobbiesInterests.value = data['hobbies_interests'] ?? '';
      _patientStatus.value = data['status'] ?? '';
    }
  }

  Future<void> loadHealthRecords(String id) async {
    _isLoadingRecords.value = true;

    final result = await _healthRepository.getRecords(id);

    _isLoadingRecords.value = false;

    if (result['error'] == true || result['data'] == null) return;

    final data = result['data'] as Map<String, dynamic>;
    final rawList = data['records'] as List<dynamic>?;
    if (rawList == null || rawList.isEmpty) return;

    _records.assignAll(
      rawList.cast<Map<String, dynamic>>().map(_normalizeRecord),
    );
  }

  Map<String, dynamic> _normalizeRecord(Map<String, dynamic> rec) {
    final isCritical = _isStatusCritical(rec['health_status'] as String?);

    String dateStr;
    try {
      final dt = DateTime.parse(rec['recorded_at'] as String);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      dateStr = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      dateStr = rec['recorded_at'] as String? ?? '';
    }

    final sys = _fmtNum(rec['systolic_bp']);
    final dia = _fmtNum(rec['diastolic_bp']);
    final tensi = sys != null && dia != null ? '$sys/$dia' : '—';

    final suhu = _fmtNum(rec['body_temperature']);
    final suhuDisplay = suhu != null ? '$suhu°C' : '—';

    final notes = _buildNotes(rec);

    final symptoms = <String>[];
    if (rec['complaints'] != null) {
      final rawComplaints = rec['complaints'].toString();
      if (rawComplaints.isNotEmpty) {
        symptoms.add(rawComplaints);
      }
    }

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
    return status == 'needs_attention' ||
        status == 'critical' ||
        status == 'warning';
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

  @override
  void onClose() {
    for (final worker in _shellWorkers) {
      worker.dispose();
    }
    super.onClose();
  }
}
