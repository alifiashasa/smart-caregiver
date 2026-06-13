import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/ai_recommendation_model.dart';
import '../controllers/rekomendasi_ai_controller.dart';

class RekomendasiAiView extends GetView<RekomendasiAiController> {
  const RekomendasiAiView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Rekomendasi AI'),
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return _buildErrorState(context);
          }

          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: controller.fetchRecommendations,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(pagePadding, 24, pagePadding, 40),
              children: [
                _buildHeader(context),
                const SizedBox(height: 22),
                if (controller.recommendations.isEmpty &&
                    !controller.isGenerating)
                  _buildEmptyState(context)
                else
                  ...controller.recommendations.map(
                    (recommendation) => _buildAiCard(context, recommendation),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.liftShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppTheme.primary,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aktivitas yang disarankan',
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dianalisis dari data kesehatan dan rutinitas pasien.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Obx(
            () => ElevatedButton.icon(
              onPressed: controller.isGenerating
                  ? null
                  : () => controller.generateRecommendation(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.primary,
              ),
              icon: controller.isGenerating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primary,
                      ),
                    )
                  : const Icon(Icons.refresh_rounded, size: 19),
              label: Text(
                controller.isGenerating
                    ? 'Menganalisis...'
                    : 'Generate Rekomendasi',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppTheme.accentSoft,
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              size: 36,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text('Belum ada rekomendasi', style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Tekan tombol generate untuk membuat rekomendasi aktivitas dari AI.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.cardDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.errorSoft,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Icon(
                  Icons.cloud_off_outlined,
                  size: 36,
                  color: AppTheme.error,
                ),
              ),
              const SizedBox(height: 18),
              Text('Gagal memuat rekomendasi', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                controller.errorMessage ?? 'Terjadi kesalahan',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton.icon(
                onPressed: controller.fetchRecommendations,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiCard(BuildContext context, AiRecommendationModel rec) {
    final textTheme = Theme.of(context).textTheme;
    final statusStyle = _statusStyle(rec);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: AppTheme.cardDecoration(
          borderColor: rec.isApproved ? AppTheme.accent : AppTheme.border,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentSoft,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          RekomendasiAiController.categoryLabel(rec.category),
                          style: textTheme.labelMedium?.copyWith(
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.timer_outlined,
                        size: 15,
                        color: AppTheme.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        RekomendasiAiController.durationLabel(
                          rec.durationMinutes,
                        ),
                        style: textTheme.labelMedium?.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    rec.activityName,
                    style: textTheme.titleLarge?.copyWith(fontSize: 19),
                  ),
                  if (rec.frequencySuggestion != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.repeat_rounded,
                          size: 15,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            rec.frequencySuggestion!,
                            style: textTheme.labelMedium?.copyWith(
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (rec.displayReason.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      rec.displayReason,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusStyle.softColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      RekomendasiAiController.statusLabel(rec.status),
                      style: textTheme.labelMedium?.copyWith(
                        color: statusStyle.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (rec.isPending) ...[
              const Divider(height: 1),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => controller.approveRecommendation(rec),
                      icon: const Icon(Icons.add_task_rounded, size: 18),
                      label: const Text('Tambahkan'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 28, color: AppTheme.border),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => controller.rejectRecommendation(rec),
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: const Text('Tolak'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.textTertiary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  _RecommendationStatusStyle _statusStyle(AiRecommendationModel rec) {
    if (rec.isApproved) {
      return const _RecommendationStatusStyle(
        color: AppTheme.primary,
        softColor: AppTheme.accentSoft,
      );
    }
    if (rec.isRejected) {
      return const _RecommendationStatusStyle(
        color: AppTheme.textTertiary,
        softColor: AppTheme.surfaceMuted,
      );
    }
    return const _RecommendationStatusStyle(
      color: AppTheme.warning,
      softColor: AppTheme.warningSoft,
    );
  }
}

class _RecommendationStatusStyle {
  final Color color;
  final Color softColor;

  const _RecommendationStatusStyle({
    required this.color,
    required this.softColor,
  });
}
