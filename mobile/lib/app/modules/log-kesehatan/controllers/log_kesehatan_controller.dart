import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/logger.dart';
import '../../../data/repositories/health_repository.dart';
import '../../../routes/app_pages.dart';

class LogKesehatanController extends GetxController {
  final HealthRepository _healthRepository;

  LogKesehatanController({required HealthRepository healthRepository})
    : _healthRepository = healthRepository;

  // ── Form controllers ──
  final cholesterolController = TextEditingController();
  final tensiController = TextEditingController();
  final uricAcidController = TextEditingController();
  final bloodSugarController = TextEditingController();
  final bodyTempController = TextEditingController();
  final heartRateController = TextEditingController();
  final spo2Controller = TextEditingController();
  final weightController = TextEditingController();
  final notesController = TextEditingController();
  final complaintsController = TextEditingController();

  // ── Reactive state ──
  final _isLoading = false.obs;
  final _patientName = ''.obs;

  // ── Public getters ──
  bool get isLoading => _isLoading.value;
  String get patientName => _patientName.value;

  String? _elderlyId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      _elderlyId = args['elderly_id']?.toString();
      _patientName.value = args['name'] as String? ?? '';
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
    if (_isLoading.value) return;

    double? systolicBp;
    double? diastolicBp;
    if (tensiController.text.contains('/')) {
      final parts = tensiController.text.split('/');
      systolicBp = double.tryParse(parts[0].trim());
      diastolicBp = double.tryParse(parts[1].trim());
    } else if (tensiController.text.isNotEmpty) {
      systolicBp = double.tryParse(tensiController.text.trim());
    }

    final cholesterol = double.tryParse(cholesterolController.text.trim());
    final uricAcid = double.tryParse(uricAcidController.text.trim());
    final bloodSugar = double.tryParse(bloodSugarController.text.trim());
    final bodyTemp = double.tryParse(bodyTempController.text.trim());
    final heartRate = double.tryParse(heartRateController.text.trim());
    final spo2 = double.tryParse(spo2Controller.text.trim());
    final weight = double.tryParse(weightController.text.trim());
    final notes = notesController.text.trim();
    final complaints = complaintsController.text.trim();

    if (_elderlyId == null || _elderlyId!.isEmpty) {
      _isLoading.value = false;
      Get.snackbar(
        'Error',
        'Data lansia tidak ditemukan. Silakan pilih lansia dari halaman utama.',
        backgroundColor: const Color(0xFFFFDAD6),
        colorText: const Color(0xFF1C1B1C),
      );
      return;
    }

    _isLoading.value = true;

    final result = await _healthRepository.createRecord(
      elderlyId: _elderlyId!,
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

    _isLoading.value = false;

    String healthStatus = "Normal";
    String healthMessage =
        "Semua indikator vital dalam batas normal. Tetap pertahankan pola makan sehat dan rutinitas aktivitas harian.";
    double fuzzyCardioScore = 0.0;
    double fuzzyMetabolicScore = 0.0;
    double fuzzyInfectionScore = 0.0;

    if (result['error'] == true) {
      final errMsg =
          result['message'] as String? ??
          'Gagal menyimpan data kesehatan. Periksa koneksi Anda.';
      final detailBody = result['detail_body'] as Map<String, dynamic>?;
      log.error(
        'submitHealthRecord gagal',
        data: {
          'message': errMsg,
          'statusCode': result['statusCode'],
          if (detailBody case final body?) 'detail': body,
        },
      );
      Get.snackbar(
        'Gagal',
        errMsg,
        backgroundColor: Colors.red.shade100,
        duration: const Duration(seconds: 3),
      );

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

    // 6. Navigate to success page — pass elderly info for refresh on return
    Get.offNamed(
      Routes.SUCCESS_LOG_KESEHATAN,
      arguments: {
        "status": healthStatus,
        "message": healthMessage,
        "cardio_score": fuzzyCardioScore,
        "metabolic_score": fuzzyMetabolicScore,
        "infection_score": fuzzyInfectionScore,
        "elderly_id": _elderlyId,
        "name": _patientName.value,
      },
    );
  }

  double _readScore(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
