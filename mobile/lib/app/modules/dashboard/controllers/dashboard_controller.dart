import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/dashboard_api.dart';
import '../../../data/elderly_api.dart';
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
  final ElderlyApi _elderlyApi = ElderlyApi();
  final HealthApi _healthApi = HealthApi();

  final healthMetrics = <Map<String, dynamic>>[
    {
      'id': 'cholesterol',
      'color': const Color(0xFFFDDCC9),
      'icon': Icons.water_drop_outlined,
      'iconColor': const Color(0xFFE65100),
      'title': 'Kolesterol',
      'value': '-',
      'unit': 'mg/dL',
    },
    {
      'id': 'tensi',
      'color': const Color(0xFFD6E7D0),
      'icon': Icons.bloodtype_outlined,
      'iconColor': const Color(0xFF2E7D32),
      'title': 'Tensi',
      'value': '-',
      'unit': 'mmHg',
    },
    {
      'id': 'uric_acid',
      'color': const Color(0xFFEEEEEE),
      'icon': Icons.science_outlined,
      'iconColor': const Color(0xFF424242),
      'title': 'Asam Urat',
      'value': '-',
      'unit': 'mg/dL',
    },
    {
      'id': 'blood_sugar',
      'color': const Color(0xFFFFDAD6),
      'icon': Icons.opacity,
      'iconColor': const Color(0xFFC62828),
      'title': 'Gula Darah',
      'value': '-',
      'unit': 'mg/dL',
    },
    {
      'id': 'body_temp',
      'color': const Color(0xFFE2E2E2),
      'icon': Icons.thermostat_outlined,
      'iconColor': const Color(0xFFEF6C00),
      'title': 'Suhu',
      'value': '-',
      'unit': '°C',
    },
    {
      'id': 'spo2',
      'color': const Color(0xFFFDDCC9),
      'icon': Icons.air,
      'iconColor': const Color(0xFF1565C0),
      'title': 'Saturasi',
      'value': '-',
      'unit': '%',
    },
    {
      'id': 'weight',
      'color': const Color(0xFFEEEEEE),
      'icon': Icons.monitor_weight_outlined,
      'iconColor': const Color(0xFF4E342E),
      'title': 'Berat Badan',
      'value': '-',
      'unit': 'kg',
    },
    {
      'id': 'heart_rate',
      'color': const Color(0xFFD6E7D0),
      'icon': Icons.favorite_border,
      'iconColor': const Color(0xFFC62828),
      'title': 'Detak Jantung',
      'value': '-',
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

  Future<void> loadTrends() => _loadTrends();

  Future<void> _loadPatientProfile(int id) async {
    final result = await _elderlyApi.getById(id);

    if (result['error'] == true || result['data'] == null) return;

    final data = result['data'] as Map<String, dynamic>;
    patientName.value = data['full_name'] ?? patientName.value;
    patientAge.value = data['age'] != null
        ? '${data['age']} Tahun'
        : patientAge.value;
    patientGender.value = data['gender'] ?? patientGender.value;
    patientImage.value = data['photo_url'] ?? patientImage.value;
  }

  Future<void> _loadTrends() async {
    if (elderlyId.value == 0) return;

    isLoading.value = true;

    final range = selectedTrendFilter.value == '30 Hari' ? '30d' : '7d';

    final result = await _dashboardApi.getTrends(elderlyId.value, range: range);

    isLoading.value = false;

    if (result['error'] == true) {
      return;
    }

    final data = result['data'];
    if (data != null) {
      if (data['data_points'] != null) {
        trendDataPoints.value = (data['data_points'] as List<dynamic>)
            .map(
              (point) => _normalizeTrendDataPoint(
                Map<String, dynamic>.from(point as Map),
              ),
            )
            .toList();
      }
      if (data['summary'] != null) {
        trendSummary.value = Map<String, dynamic>.from(data['summary']);
      }
      _detectAvailableParams();
    }
  }

  Future<void> loadLatestHealthRecord() => _loadLatestRecord();

  Future<void> _loadLatestRecord() async {
    if (elderlyId.value == 0) return;

    final result = await _healthApi.getRecords(elderlyId.value, limit: 1);

    if (result['error'] == true || result['data'] == null) return;

    final data = result['data'] as Map<String, dynamic>;
    final records = data['records'] as List<dynamic>?;
    if (records == null || records.isEmpty) return;

    final latest = records.first as Map<String, dynamic>;

    if (latest['systolic_bp'] != null && latest['diastolic_bp'] != null) {
      final sys = '${latest['systolic_bp']}';
      final dia = '${latest['diastolic_bp']}';
      updateHealthMetric('tensi', '$sys/$dia');
    }
    _updateMetricFromRecord(latest, 'cholesterol', 'cholesterol');
    _updateMetricFromRecord(latest, 'uric_acid', 'uric_acid');
    _updateMetricFromRecord(latest, 'blood_sugar', 'blood_sugar');
    _updateMetricFromRecord(latest, 'body_temp', 'body_temperature');
    _updateMetricFromRecord(latest, 'spo2', 'spo2_level');
    _updateMetricFromRecord(latest, 'weight', 'body_weight');
    _updateMetricFromRecord(latest, 'heart_rate', 'heart_rate');
  }

  void _updateMetricFromRecord(
    Map<String, dynamic> record,
    String metricId,
    String field,
  ) {
    final value = record[field];
    if (value != null) {
      updateHealthMetric(metricId, '$value');
    }
  }

  Map<String, dynamic> _normalizeTrendDataPoint(Map<String, dynamic> point) {
    final normalized = <String, dynamic>{'date': point['date']};
    final records = point['records'];
    if (records is! List || records.isEmpty) return normalized;

    for (final param in trendParamLabels.keys) {
      final values = records
          .map((record) => record is Map ? record[param] : null)
          .map(
            (value) => value is num
                ? value.toDouble()
                : double.tryParse(value?.toString() ?? ''),
          )
          .whereType<double>()
          .toList();
      if (values.isNotEmpty) {
        final total = values.reduce((a, b) => a + b);
        normalized[param] = total / values.length;
      }
    }

    return normalized;
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
        elderlyId.value = Get.arguments['elderly_id'] is int
            ? Get.arguments['elderly_id']
            : int.tryParse(Get.arguments['elderly_id'].toString()) ?? 0;
      }
    }

    if (elderlyId.value != 0) {
      _loadDashboardData();
    }

    ever(selectedTrendFilter, (_) => loadTrends());
  }

  Future<void> _loadDashboardData() async {
    await _loadPatientProfile(elderlyId.value);
    await _loadLatestRecord();
    await _loadTrends();
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
