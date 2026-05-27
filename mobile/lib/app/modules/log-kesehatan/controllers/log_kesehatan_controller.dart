import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/health_api.dart';
import '../../../routes/app_pages.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class LogKesehatanController extends GetxController {
  // Input Controllers matching backend HealthRecordCreate schema
  final cholesterolController = TextEditingController(); // mg/dL
  final tensiController = TextEditingController(); // Format: 120/80
  final uricAcidController = TextEditingController(); // mg/dL
  final bloodSugarController = TextEditingController(); // mg/dL
  final bodyTempController = TextEditingController(); // °C
  final heartRateController = TextEditingController(); // bpm
  final spo2Controller = TextEditingController(); // %
  final weightController = TextEditingController(); // kg
  final notesController = TextEditingController(); // daily_notes
  final complaintsController = TextEditingController(); // complaints

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
  }

  @override
  void onClose() {
    cholesterolController.dispose();
    tensiController.dispose();
    uricAcidController.dispose();
    bloodSugarController.dispose();
    bodyTempController.dispose();
    heartRateController.dispose();
    spo2Controller.dispose();
    weightController.dispose();
    notesController.dispose();
    complaintsController.dispose();
    super.onClose();
  }

  Future<void> submitHealthRecord() async {
    // 1. Parsing Tensi to systolic_bp and diastolic_bp
    double? systolicBp;
    double? diastolicBp;
    if (tensiController.text.contains('/')) {
      final parts = tensiController.text.split('/');
      systolicBp = double.tryParse(parts[0].trim());
      diastolicBp = double.tryParse(parts[1].trim());
    } else if (tensiController.text.isNotEmpty) {
      systolicBp = double.tryParse(tensiController.text.trim());
    }

    // 2. Map other fields
    final cholesterol = double.tryParse(cholesterolController.text.trim());
    final uricAcid = double.tryParse(uricAcidController.text.trim());
    final bloodSugar = double.tryParse(bloodSugarController.text.trim());
    final bodyTemp = double.tryParse(bodyTempController.text.trim());
    final heartRate = double.tryParse(heartRateController.text.trim());
    final spo2 = double.tryParse(spo2Controller.text.trim());
    final weight = double.tryParse(weightController.text.trim());
    final notes = notesController.text.trim();
    final complaints = complaintsController.text.trim();

    // 3. Call API
    isLoading.value = true;

    final result = await _api.createRecord(
      elderlyId: elderlyId ?? 0,
      systolicBp: systolicBp,
      diastolicBp: diastolicBp,
      heartRate: heartRate,
      spo2Level: spo2,
      bloodSugar: bloodSugar,
      cholesterol: cholesterol,
      uricAcid: uricAcid,
      bodyWeight: weight,
      bodyTemperature: bodyTemp,
      dailyNotes: notes.isNotEmpty ? notes : null,
      complaints: complaints.isNotEmpty ? complaints : null,
    );

    isLoading.value = false;

    // 4. Parse response for success page
    String healthStatus = "Normal";
    String healthMessage =
        "Semua indikator vital dalam batas normal. Tetap pertahankan pola makan sehat dan rutinitas aktivitas harian.";
    double fuzzyCardioScore = 0.0;
    double fuzzyMetabolicScore = 0.0;
    double fuzzyInfectionScore = 0.0;

    if (result['error'] == true) {
      Get.snackbar(
        'Gagal',
        'Gagal menyimpan data kesehatan. Periksa koneksi Anda.',
        backgroundColor: Colors.red.shade100,
        duration: const Duration(seconds: 3),
      );

      // Fallback: mock analysis so user still sees result
      if ((systolicBp != null && systolicBp > 180) ||
          (bloodSugar != null && bloodSugar > 250)) {
        healthStatus = "Kritis";
        healthMessage =
            "Kondisi terdeteksi sangat kritis! Segera hubungi tenaga medis atau dokter untuk penanganan darurat.";
      } else if ((systolicBp != null && systolicBp > 140) ||
          (bloodSugar != null && bloodSugar > 150)) {
        healthStatus = "Perhatian";
        healthMessage =
            "Beberapa metrik vital seperti tekanan darah atau gula darah terpantau tinggi. Pertimbangkan untuk menjadwalkan pemeriksaan lebih lanjut.";
      }
    } else {
      final data = result['data'] as Map<String, dynamic>?;
      if (data != null) {
        healthStatus =
            (data['health_status'] as String?)?.capitalizeFirst ?? healthStatus;

        final fuzzy = data['fuzzy_analysis'] as Map<String, dynamic>?;
        if (fuzzy != null) {
          final status = fuzzy['final_status'] as String?;
          if (status != null) {
            healthStatus = status.toString().capitalizeFirst ?? healthStatus;
          }
        }

        fuzzyCardioScore = _readScore(data['cardio_score']);
        fuzzyMetabolicScore = _readScore(data['metabolic_score']);
        fuzzyInfectionScore = _readScore(data['infection_score']);
      }
    }

    // 5. Update Dashboard Metrics
    try {
      final dashboardCtrl = Get.find<DashboardController>();
      if (cholesterolController.text.isNotEmpty) {
        dashboardCtrl.updateHealthMetric(
          'cholesterol',
          cholesterolController.text.trim(),
        );
      }
      if (tensiController.text.isNotEmpty) {
        dashboardCtrl.updateHealthMetric('tensi', tensiController.text.trim());
      }
      if (uricAcidController.text.isNotEmpty) {
        dashboardCtrl.updateHealthMetric(
          'uric_acid',
          uricAcidController.text.trim(),
        );
      }
      if (bloodSugarController.text.isNotEmpty) {
        dashboardCtrl.updateHealthMetric(
          'blood_sugar',
          bloodSugarController.text.trim(),
        );
      }
      if (bodyTempController.text.isNotEmpty) {
        dashboardCtrl.updateHealthMetric(
          'body_temp',
          bodyTempController.text.trim(),
        );
      }
      if (heartRateController.text.isNotEmpty) {
        dashboardCtrl.updateHealthMetric(
          'heart_rate',
          heartRateController.text.trim(),
        );
      }
      if (spo2Controller.text.isNotEmpty) {
        dashboardCtrl.updateHealthMetric('spo2', spo2Controller.text.trim());
      }
      if (weightController.text.isNotEmpty) {
        dashboardCtrl.updateHealthMetric(
          'weight',
          weightController.text.trim(),
        );
      }
    } catch (e) {
      debugPrint('DashboardController not found, skipping UI update');
    }

    // 6. Navigate to success page
    Get.offNamed(
      Routes.SUCCESS_LOG_KESEHATAN,
      arguments: {
        "status": healthStatus,
        "message": healthMessage,
        "cardio_score": fuzzyCardioScore,
        "metabolic_score": fuzzyMetabolicScore,
        "infection_score": fuzzyInfectionScore,
      },
    );
  }

  double _readScore(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
