import 'package:get/get.dart';
import '../../../data/health_api.dart';

class DetailHistoryController extends GetxController {
  final records = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final patientName = ''.obs;
  final selectedIndex = 0.obs;
  final HealthApi _api = HealthApi();

  int? elderlyId;

  /// The currently selected/focused record.
  Map<String, dynamic>? get selectedRecord =>
      records.isNotEmpty && selectedIndex.value < records.length
          ? records[selectedIndex.value]
          : null;

  /// The fuzzy_analysis map from [selectedRecord].
  Map<String, dynamic>? get fuzzyAnalysis =>
      selectedRecord?['fuzzy_analysis'] as Map<String, dynamic>?;

  /// The health_status string from [selectedRecord].
  String? get healthStatus => selectedRecord?['health_status'] as String?;

  /// Human-readable date for the selected record.
  String get selectedRecordDate {
    final rec = selectedRecord;
    if (rec == null) return '';
    try {
      final dt = DateTime.parse(rec['recorded_at'] as String);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return rec['recorded_at'] as String? ?? '';
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      elderlyId = args['elderly_id'] is int
          ? args['elderly_id']
          : int.tryParse(args['elderly_id']?.toString() ?? '');
      patientName.value = args['name'] as String? ?? '';
    }
    if (elderlyId != null) {
      loadRecords();
    }
  }

  Future<void> loadRecords() async {
    isLoading.value = true;

    final result = await _api.getRecords(elderlyId ?? 0);

    isLoading.value = false;

    if (result['error'] == true) {
      // Silent fail — records stays empty
      return;
    }

    final data = result['data'] as Map<String, dynamic>?;
    if (data != null && data['records'] != null) {
      records.value = List<Map<String, dynamic>>.from(data['records'] as List);
      // Sort by recorded_at descending (newest first)
      records.sort((a, b) {
        final aDate = _parseDate(a['recorded_at']);
        final bDate = _parseDate(b['recorded_at']);
        return bDate.compareTo(aDate);
      });
      // Select the first (newest) record by default
      selectedIndex.value = 0;
    }
  }

  /// Switch the displayed record.
  void selectRecord(int index) {
    if (index >= 0 && index < records.length) {
      selectedIndex.value = index;
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
