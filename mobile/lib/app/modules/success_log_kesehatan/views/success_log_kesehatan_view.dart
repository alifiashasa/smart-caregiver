import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/success_log_kesehatan_controller.dart';

class SuccessLogKesehatanView extends GetView<SuccessLogKesehatanController> {
  const SuccessLogKesehatanView({super.key});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
      case 'kritis':
        return const Color(0xFFD32F2F);
      case 'warning':
      case 'perhatian':
        return const Color(0xFFE6A817);
      default:
        return const Color(0xFF6A9963);
    }
  }

  Color _scoreColor(double score) {
    if (score >= 50) return const Color(0xFFD32F2F);
    if (score >= 35) return const Color(0xFFE6A817);
    return const Color(0xFF6A9963);
  }

  Widget _analysisCard(String label, double score) {
    final color = _scoreColor(score);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1C1B1C),
                fontSize: 14,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              score.toStringAsFixed(1),
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F3E6),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Color(0xFF6A9963),
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Data Berhasil Disimpan!',
                style: TextStyle(
                  color: Color(0xFF1C1B1C),
                  fontSize: 24,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'Data kesehatan lansia telah berhasil dicatat ke dalam sistem. Berikut adalah ringkasan hasil analisis.',
                style: TextStyle(
                  color: Color(0xFF77767B),
                  fontSize: 14,
                  fontFamily: 'Plus Jakarta Sans',
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Analysis Card
              Obx(() {
                final statusColor = _statusColor(controller.healthStatus);

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'HASIL ANALISIS',
                        style: TextStyle(
                          color: Color(0xFF77767B),
                          fontSize: 11,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.sentiment_satisfied_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.healthStatus,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.healthMessage,
                        style: const TextStyle(
                          color: Color(0xFF1C1B1C),
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _analysisCard(
                        'Kardiovaskular',
                        controller.fuzzyCardioScore,
                      ),
                      const SizedBox(height: 10),
                      _analysisCard(
                        'Metabolik',
                        controller.fuzzyMetabolicScore,
                      ),
                      const SizedBox(height: 10),
                      _analysisCard('Infeksi', controller.fuzzyInfectionScore),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 32),

              // Back Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.goToDashboard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF192126),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
