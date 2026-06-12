import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../routes/app_pages.dart';

class DashboardController extends GetxController {
  final DashboardRepository _dashboardRepository;

  DashboardController({required DashboardRepository dashboardRepository})
      : _dashboardRepository = dashboardRepository;

  // ── Reactive state ──
  final _currentIndex = 0.obs;
  final _selectedTrendFilter = '7 Hari'.obs;

  // Patient Data
  final _patientName = 'Ibu Siti'.obs;
  final _patientAge = '55 Tahun'.obs;
  final _patientImage = 'assets/images/patient_ibu_siti.png'.obs;
  final _patientGender = 'Perempuan'.obs;
  final _elderlyId = ''.obs;

  final _isLoading = false.obs;
  final _trendDataPoints = [].obs;
  final _trendSummary = <String, dynamic>{}.obs;

  final _healthMetrics = <Map<String, dynamic>>[
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

  // ── Trend chart params ──
  final _selectedTrendParam = 'blood_sugar'.obs;
  final _availableParams = <String>[].obs;

  // ── Public getters ──
  int get currentIndex => _currentIndex.value;
  String get selectedTrendFilter => _selectedTrendFilter.value;
  String get patientName => _patientName.value;
  String get patientAge => _patientAge.value;
  String get patientImage => _patientImage.value;
  String get patientGender => _patientGender.value;
  String get elderlyId => _elderlyId.value;
  bool get isLoading => _isLoading.value;
  List get trendDataPoints => _trendDataPoints;
  Map<String, dynamic> get trendSummary => _trendSummary;
  List<Map<String, dynamic>> get healthMetrics => _healthMetrics;
  String get selectedTrendParam => _selectedTrendParam.value;
  List<String> get availableParams => _availableParams;

  set currentIndex(int value) => _currentIndex.value = value;
  set selectedTrendFilter(String value) => _selectedTrendFilter.value = value;
  set selectedTrendParam(String value) => _selectedTrendParam.value = value;

  void updateHealthMetric(String id, String newValue) {
    if (newValue.isEmpty) return;
    final index = _healthMetrics.indexWhere((element) => element['id'] == id);
    if (index != -1) {
      final item = Map<String, dynamic>.from(_healthMetrics[index]);
      item['value'] = newValue;
      _healthMetrics[index] = item;
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

  Future<void> loadTrends() => _loadTrends();

  Future<void> _loadPatientProfile(String id) async {
    final result = await _dashboardRepository.getElderlyProfile(id);

    if (result['error'] == true || result['data'] == null) return;

    final data = result['data'] as Map<String, dynamic>;
    _patientName.value = data['full_name'] ?? _patientName.value;
    _patientAge.value =
        data['age'] != null ? '${data['age']} Tahun' : _patientAge.value;
    _patientGender.value = data['gender'] ?? _patientGender.value;
    _patientImage.value = data['photo_url'] ?? _patientImage.value;
  }

  Future<void> _loadTrends() async {
    if (_elderlyId.value.isEmpty) return;

    _isLoading.value = true;

    final range = _selectedTrendFilter.value == '30 Hari' ? '30d' : '7d';

    final result =
        await _dashboardRepository.getTrends(_elderlyId.value, range: range);

    _isLoading.value = false;

    if (result['error'] == true) return;

    final data = result['data'];
    if (data != null) {
      if (data['data_points'] != null) {
        _trendDataPoints.value = (data['data_points'] as List<dynamic>)
            .map((point) => _normalizeTrendDataPoint(
                  Map<String, dynamic>.from(point as Map),
                ))
            .toList();
      }
      if (data['summary'] != null) {
        _trendSummary.value = Map<String, dynamic>.from(data['summary']);
      }
      _detectAvailableParams();
    }
  }

  Future<void> loadLatestHealthRecord() => _loadLatestRecord();

  Future<void> _loadLatestRecord() async {
    if (_elderlyId.value.isEmpty) return;

    final result =
        await _dashboardRepository.getLatestHealthRecord(_elderlyId.value, limit: 1);

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

    for (final param in _trendParamLabels.keys) {
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

  static const Map<String, String> _trendParamLabels = {
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

  static Map<String, String> get trendParamLabels => _trendParamLabels;

  void _detectAvailableParams() {
    final params = <String>{};
    for (final dp in _trendDataPoints) {
      for (final entry in _trendParamLabels.keys) {
        if (dp[entry] != null) {
          params.add(entry);
        }
      }
    }
    _availableParams.value = params.toList();
    if (params.isNotEmpty && !params.contains(_selectedTrendParam.value)) {
      _selectedTrendParam.value = params.first;
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      if (Get.arguments['from'] != null) {
        _currentIndex.value = Get.arguments['from'];
      }
      if (Get.arguments['name'] != null) {
        _patientName.value = Get.arguments['name'];
      }
      if (Get.arguments['age'] != null) {
        _patientAge.value = Get.arguments['age'];
      }
      if (Get.arguments['image'] != null) {
        _patientImage.value = Get.arguments['image'];
      }
      if (Get.arguments['gender'] != null) {
        _patientGender.value = Get.arguments['gender'];
      }
      if (Get.arguments['elderly_id'] != null) {
        _elderlyId.value = Get.arguments['elderly_id'].toString();
      }
    }

    if (_elderlyId.value.isNotEmpty) {
      _loadDashboardData();
    }

    ever(_selectedTrendFilter, (_) => loadTrends());
  }

  Future<void> _loadDashboardData() async {
    if (_elderlyId.value.isNotEmpty) {
      await _loadPatientProfile(_elderlyId.value);
      await _loadLatestRecord();
      await _loadTrends();
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (_currentIndex.value != 0) {
      Future.delayed(const Duration(milliseconds: 10), () {
        _currentIndex.value = 0;
      });
    }
  }
}
