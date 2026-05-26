import 'package:get/get.dart';
import '../../../data/health_api.dart';

class DetailHistoryController extends GetxController {
  final records = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final patientName = ''.obs;
  final HealthApi _api = HealthApi();

  int? elderlyId;

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
    }
  }
}
