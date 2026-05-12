import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  void submitHealthRecord() {
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

    // In a real app we would send this payload to backend via API
    final payload = {
      "systolic_bp": systolicBp,
      "diastolic_bp": diastolicBp,
      "heart_rate": heartRate,
      "spo2_level": spo2,
      "blood_sugar": bloodSugar,
      "cholesterol": cholesterol,
      "uric_acid": uricAcid,
      "body_weight": weight,
      "body_temperature": bodyTemp,
      "daily_notes": notes.isNotEmpty ? notes : null,
      "complaints": complaints.isNotEmpty ? complaints : null,
    };

    debugPrint("MOCK SUBMIT PAYLOAD: $payload");

    // Simulasi hasil dari Fuzzy Logic Backend
    String healthStatus = "Normal";
    String healthMessage =
        "Semua indikator vital dalam batas normal. Tetap pertahankan pola makan sehat dan rutinitas aktivitas harian.";

    if ((systolicBp != null && systolicBp > 140) ||
        (bloodSugar != null && bloodSugar > 150)) {
      healthStatus = "Perhatian";
      healthMessage =
          "Beberapa metrik vital seperti tekanan darah atau gula darah terpantau tinggi. Pertimbangkan untuk menjadwalkan pemeriksaan lebih lanjut.";
    }

    if ((systolicBp != null && systolicBp > 180) ||
        (bloodSugar != null && bloodSugar > 250)) {
      healthStatus = "Kritis";
      healthMessage =
          "Kondisi terdeteksi sangat kritis! Segera hubungi tenaga medis atau dokter untuk penanganan darurat.";
    }

    // Update Dashboard Metrics
    try {
      final dashboardCtrl = Get.find<DashboardController>();
      if (cholesterolController.text.isNotEmpty)
        dashboardCtrl.updateHealthMetric(
          'cholesterol',
          cholesterolController.text.trim(),
        );
      if (tensiController.text.isNotEmpty)
        dashboardCtrl.updateHealthMetric('tensi', tensiController.text.trim());
      if (uricAcidController.text.isNotEmpty)
        dashboardCtrl.updateHealthMetric(
          'uric_acid',
          uricAcidController.text.trim(),
        );
      if (bloodSugarController.text.isNotEmpty)
        dashboardCtrl.updateHealthMetric(
          'blood_sugar',
          bloodSugarController.text.trim(),
        );
      if (bodyTempController.text.isNotEmpty)
        dashboardCtrl.updateHealthMetric(
          'body_temp',
          bodyTempController.text.trim(),
        );
      if (heartRateController.text.isNotEmpty)
        dashboardCtrl.updateHealthMetric(
          'heart_rate',
          heartRateController.text.trim(),
        );
      if (spo2Controller.text.isNotEmpty)
        dashboardCtrl.updateHealthMetric('spo2', spo2Controller.text.trim());
      if (weightController.text.isNotEmpty)
        dashboardCtrl.updateHealthMetric(
          'weight',
          weightController.text.trim(),
        );
    } catch (e) {
      debugPrint('DashboardController not found, skipping UI update');
    }

    // Navigasi ke halaman sukses membawa argumen hasil analisis
    Get.offNamed(
      Routes.SUCCESS_LOG_KESEHATAN,
      arguments: {"status": healthStatus, "message": healthMessage},
    );
  }
}
