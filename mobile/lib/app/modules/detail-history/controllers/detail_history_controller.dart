import 'package:get/get.dart';
import '../../../data/models/patient_route_args.dart';
import '../../../data/repositories/health_repository.dart';

class DetailHistoryController extends GetxController {
  final HealthRepository _healthRepository;

  DetailHistoryController({required HealthRepository healthRepository})
    : _healthRepository = healthRepository;

  // ── Reactive state ──
  final _records = <Map<String, dynamic>>[].obs;
  final _isLoading = false.obs;
  final _patientName = ''.obs;
  final _selectedIndex = 0.obs;

  // ── Public getters ──
  List<Map<String, dynamic>> get records => _records;
  bool get isLoading => _isLoading.value;
  String get patientName => _patientName.value;
  int get selectedIndex => _selectedIndex.value;

  Map<String, dynamic>? get selectedRecord =>
      _records.isNotEmpty && _selectedIndex.value < _records.length
      ? _records[_selectedIndex.value]
      : null;

  Map<String, dynamic>? get fuzzyAnalysis =>
      selectedRecord?['fuzzy_analysis'] as Map<String, dynamic>?;

  String? get healthStatus => selectedRecord?['health_status'] as String?;

  String get selectedRecordDate {
    final rec = selectedRecord;
    if (rec == null) return '';
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
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return rec['recorded_at'] as String? ?? '';
    }
  }

  String? _elderlyId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = PatientRouteArgs.fromMap(Get.arguments as Map);
      _elderlyId = args.elderlyId;
      _patientName.value = args.name;
    }
    if (_elderlyId != null) {
      loadRecords();
    }
  }

  Future<void> loadRecords() async {
    _isLoading.value = true;

    final result = await _healthRepository.getRecords(_elderlyId ?? '');

    _isLoading.value = false;

    if (result['error'] == true) return;

    final data = result['data'] as Map<String, dynamic>?;
    if (data != null && data['records'] != null) {
      _records.value = List<Map<String, dynamic>>.from(data['records'] as List);
      _records.sort((a, b) {
        final aDate = _parseDate(a['recorded_at']);
        final bDate = _parseDate(b['recorded_at']);
        return bDate.compareTo(aDate);
      });
      _selectedIndex.value = 0;
    }
  }

  void selectRecord(int index) {
    if (index >= 0 && index < _records.length) {
      _selectedIndex.value = index;
    }
  }

  DateTime _parseDate(dynamic dateStr) {
    if (dateStr == null) return DateTime(2000);
    try {
      return DateTime.parse(dateStr.toString());
    } catch (_) {
      return DateTime(2000);
    }
  }
}
