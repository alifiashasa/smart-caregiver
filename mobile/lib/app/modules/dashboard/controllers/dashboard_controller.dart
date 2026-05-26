import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/dashboard_api.dart';
import '../../../data/health_api.dart';
import '../../../routes/app_pages.dart';

class DashboardController extends GetxController {
  final currentIndex = 0.obs;
  final selectedTrendFilter = '7 Hari'.obs;

  // Patient Data
  final patientName = 'Ibu Siti'.obs;
  final patientAge = '55 Tahun'.obs;
  final patientImage = 'assets/images/patient_ibu_siti.png'.obs;
  final patientGender = 'Perempuan'.obs;
  final elderlyId = 0.obs;

  final isLoading = false.obs;
  final trendDataPoints = [].obs;
  final trendSummary = {}.obs;

  final DashboardApi _dashboardApi = DashboardApi();
  final HealthApi _healthApi = HealthApi();

  final healthMetrics = <Map<String, dynamic>>[
    {
      'id': 'cholesterol',
      'color': const Color(0xFFFDDCC9),
      'icon': Icons.water_drop_outlined,
      'iconColor': const Color(0xFFE65100),
      'title': 'Kolesterol',
      'value': '180',
      'unit': 'mg/dL',
    },
    {
      'id': 'tensi',
      'color': const Color(0xFFD6E7D0),
      'icon': Icons.bloodtype_outlined,
      'iconColor': const Color(0xFF2E7D32),
      'title': 'Tensi',
      'value': '120/80',
      'unit': 'mmHg',
    },
    {
      'id': 'uric_acid',
      'color': const Color(0xFFEEEEEE),
      'icon': Icons.science_outlined,
      'iconColor': const Color(0xFF424242),
      'title': 'Asam Urat',
      'value': '5.5',
      'unit': 'mg/dL',
    },
    {
      'id': 'blood_sugar',
      'color': const Color(0xFFFFDAD6),
      'icon': Icons.opacity,
      'iconColor': const Color(0xFFC62828),
      'title': 'Gula Darah',
      'value': '110',
      'unit': 'mg/dL',
    },
    {
      'id': 'body_temp',
      'color': const Color(0xFFE2E2E2),
      'icon': Icons.thermostat_outlined,
      'iconColor': const Color(0xFFEF6C00),
      'title': 'Suhu',
      'value': '36.5',
      'unit': '°C',
    },
    {
      'id': 'spo2',
      'color': const Color(0xFFFDDCC9),
      'icon': Icons.air,
      'iconColor': const Color(0xFF1565C0),
      'title': 'Saturasi',
      'value': '98',
      'unit': '%',
    },
    {
      'id': 'weight',
      'color': const Color(0xFFEEEEEE),
      'icon': Icons.monitor_weight_outlined,
      'iconColor': const Color(0xFF4E342E),
      'title': 'Berat Badan',
      'value': '70',
      'unit': 'kg',
    },
    {
      'id': 'heart_rate',
      'color': const Color(0xFFD6E7D0),
      'icon': Icons.favorite_border,
      'iconColor': const Color(0xFFC62828),
      'title': 'Detak Jantung',
      'value': '72',
      'unit': 'bpm',
    },
  ].obs;

  void updateHealthMetric(String id, String newValue) {
    if (newValue.isEmpty) return;
    final index = healthMetrics.indexWhere((element) => element['id'] == id);
    if (index != -1) {
      final item = Map<String, dynamic>.from(healthMetrics[index]);
      item['value'] = newValue;
      healthMetrics[index] = item;
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

  Future<void> loadTrends() async {
    if (elderlyId.value == 0) return;

    isLoading.value = true;

    final range = selectedTrendFilter.value == '30 Hari' ? '30d' : '7d';

    final result =
        await _dashboardApi.getTrends(elderlyId.value, range: range);

    isLoading.value = false;

    if (result['error'] == true) {
      return;
    }

    final data = result['data'];
    if (data != null) {
      if (data['data'] != null) {
        trendDataPoints.value =
            List<Map<String, dynamic>>.from(data['data']);
      }
      if (data['summary'] != null) {
        trendSummary.value = Map<String, dynamic>.from(data['summary']);
      }
      _detectAvailableParams();
    }
  }

  Future<void> loadLatestHealthRecord() async {
    if (elderlyId.value == 0) return;

    final result = await _healthApi.getRecords(elderlyId.value);

    if (result['error'] == true || result['data'] == null) return;

    final data = result['data'] as Map<String, dynamic>;
    final records = data['records'] as List<dynamic>?;
    if (records == null || records.isEmpty) return;

    final latest = records.first as Map<String, dynamic>;

    void updateMetric(String id, String value) {
      if (value == '--' || value.isEmpty) return;
      updateHealthMetric(id, value);
    }

    if (latest['systolic_bp'] != null) {
      final sys = _formatNum(latest['systolic_bp']);
      final dia = _formatNum(latest['diastolic_bp']);
      updateMetric('tensi', '$sys/$dia');
    }
    updateMetric('cholesterol', _formatNum(latest['cholesterol']));
    updateMetric('uric_acid', _formatNum(latest['uric_acid']));
    updateMetric('blood_sugar', _formatNum(latest['blood_sugar']));
    updateMetric('body_temp', _formatNum(latest['body_temperature']));
    updateMetric('spo2', _formatNum(latest['spo2_level']));
    updateMetric('weight', _formatNum(latest['body_weight']));
    updateMetric('heart_rate', _formatNum(latest['heart_rate']));
  }

  String _formatNum(dynamic value) {
    if (value == null) return '--';
    if (value is int) return value.toString();
    if (value is double) {
      if (value == value.roundToDouble()) {
        return value.toInt().toString();
      }
      return value.toStringAsFixed(1);
    }
    return value.toString();
  }

  final count = 0.obs;

  // ── Trend chart parameter selector ──
  final selectedTrendParam = 'blood_sugar'.obs;
  final availableParams = <String>[].obs;

  static const Map<String, String> trendParamLabels = {
    'systolic_bp': 'Tensi Sistolik',
    'diastolic_bp': 'Tensi Diastolik',
    'blood_sugar': 'Gula Darah',
    'heart_rate': 'Detak Jantung',
    'body_temperature': 'Suhu',
    'body_weight': 'Berat Badan',
    'cholesterol': 'Kolesterol',
    'uric_acid': 'Asam Urat',
    'spo2_level': 'Saturasi',
  };

  /// Detect which parameters actually have data in the current dataPoints
  void _detectAvailableParams() {
    final params = <String>{};
    for (final dp in trendDataPoints) {
      for (final entry in trendParamLabels.keys) {
        if (dp[entry] != null) {
          params.add(entry);
        }
      }
    }
    availableParams.value = params.toList();
    if (params.isNotEmpty && !params.contains(selectedTrendParam.value)) {
      selectedTrendParam.value = params.first;
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      if (Get.arguments['from'] != null) {
        currentIndex.value = Get.arguments['from'];
      }
      if (Get.arguments['name'] != null) {
        patientName.value = Get.arguments['name'];
      }
      if (Get.arguments['age'] != null) {
        patientAge.value = Get.arguments['age'];
      }
      if (Get.arguments['image'] != null) {
        patientImage.value = Get.arguments['image'];
      }
      if (Get.arguments['gender'] != null) {
        patientGender.value = Get.arguments['gender'];
      }
      if (Get.arguments['elderly_id'] != null) {
        elderlyId.value = Get.arguments['elderly_id'];
      }
    }

    if (elderlyId.value != 0) {
      loadTrends();
      loadLatestHealthRecord();
    }

    ever(selectedTrendFilter, (_) => loadTrends());
  }

  @override
  void onReady() {
    super.onReady();
    if (currentIndex.value != 0) {
      Future.delayed(const Duration(milliseconds: 10), () {
        currentIndex.value = 0;
      });
    }
  }
}
