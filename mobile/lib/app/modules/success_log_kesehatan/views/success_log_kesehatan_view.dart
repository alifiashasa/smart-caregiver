import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/success_log_kesehatan_controller.dart';

class SuccessLogKesehatanView extends GetView<SuccessLogKesehatanController> {
  const SuccessLogKesehatanView({super.key});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
      case 'kritis':
        return AppTheme.error;
      case 'warning':
      case 'perhatian':
        return AppTheme.warning;
      default:
        return AppTheme.success;
    }
  }

  Color _statusSoftColor(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
      case 'kritis':
        return AppTheme.errorSoft;
      case 'warning':
      case 'perhatian':
        return AppTheme.warningSoft;
      default:
        return AppTheme.successSoft;
    }
  }

  Color _scoreColor(double score) {
    if (score >= 50) return AppTheme.error;
    if (score >= 35) return AppTheme.warning;
    return AppTheme.success;
  }

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      key: const Key('success_log_scaffold'),
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(pagePadding, 40, pagePadding, 40),
          children: [
            Obx(() {
              final statusColor = _statusColor(controller.healthStatus);
              final softColor = _statusSoftColor(controller.healthStatus);

              return Column(
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      color: softColor,
                      borderRadius: BorderRadius.circular(34),
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: statusColor,
                      size: 62,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Data Berhasil Disimpan',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Data kesehatan telah dicatat. Berikut ringkasan hasil analisis terbaru.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildAnalysisCard(context, statusColor, softColor),
                ],
              );
            }),
            const SizedBox(height: 28),
            ElevatedButton(
              key: const Key('done_button'),
              onPressed: controller.goToDashboard,
              child: const Text('Selesai'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(
    BuildContext context,
    Color statusColor,
    Color softColor,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: [
          Text(
            'HASIL ANALISIS',
            style: textTheme.labelMedium?.copyWith(
              color: AppTheme.textTertiary,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: softColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.health_and_safety_rounded,
                  color: statusColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  controller.healthStatus,
                  style: textTheme.labelLarge?.copyWith(color: statusColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            controller.healthMessage,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 20),
          _analysisCard(context, 'Kardiovaskular', controller.fuzzyCardioScore),
          const SizedBox(height: 10),
          _analysisCard(context, 'Metabolik', controller.fuzzyMetabolicScore),
          const SizedBox(height: 10),
          _analysisCard(context, 'Infeksi', controller.fuzzyInfectionScore),
        ],
      ),
    );
  }

  Widget _analysisCard(BuildContext context, String label, double score) {
    final color = _scoreColor(score);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: textTheme.labelLarge)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              score.toStringAsFixed(1),
              style: textTheme.labelLarge?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
