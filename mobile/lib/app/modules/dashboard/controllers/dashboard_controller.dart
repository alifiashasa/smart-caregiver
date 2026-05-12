import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class DashboardController extends GetxController {
  final currentIndex = 0.obs;
  final selectedTrendFilter = '7 Hari'.obs;

  // Patient Data
  final patientName = 'Ibu Siti'.obs;
  final patientAge = '55 Tahun'.obs;
  final patientImage = 'assets/images/patient_ibu_siti.png'.obs;
  final patientGender = 'Perempuan'.obs;

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

  final count = 0.obs;
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
    }
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
