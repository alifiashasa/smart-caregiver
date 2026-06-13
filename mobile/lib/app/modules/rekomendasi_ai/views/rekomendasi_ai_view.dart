import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/ai_recommendation_model.dart';
import '../controllers/rekomendasi_ai_controller.dart';

class RekomendasiAiView extends GetView<RekomendasiAiController> {
  const RekomendasiAiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.80),
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F4), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Rekomendasi AI',
          style: TextStyle(
            color: Color(0xFF1C1917),
            fontSize: 19,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.40,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF192126)),
          );
        }

        if (controller.errorMessage != null) {
          return _buildErrorState();
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                if (controller.recommendations.isEmpty &&
                    !controller.isGenerating)
                  _buildEmptyState()
                else
                  ...controller.recommendations.asMap().entries.map(
                    (entry) => _buildAiCard(entry.value, entry.key),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFBBF246),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF192126),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Dianalisis dari data kesehatan dan aktivitas',
                  style: TextStyle(
                    color: Color(0xFF47464B),
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Obx(
          () => SizedBox(
            height: 36,
            child: ElevatedButton.icon(
              onPressed: controller.isGenerating
                  ? null
                  : () => controller.generateRecommendation(),
              icon: controller.isGenerating
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF192126),
                      ),
                    )
                  : const Icon(Icons.refresh, size: 16),
              label: Text(
                controller.isGenerating ? 'Memproses...' : 'Generate',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBBF246),
                foregroundColor: const Color(0xFF192126),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            size: 48,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada rekomendasi',
            style: TextStyle(
              color: Color(0xFF77767B),
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tekan tombol Generate untuk mendapatkan\nrekomendasi aktivitas dari AI',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFA3A1A6),
              fontSize: 14,
              fontFamily: 'Plus Jakarta Sans',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF77767B),
                fontSize: 14,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.fetchRecommendations(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF192126),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiCard(AiRecommendationModel rec, int index) {
    final status = rec.status;
    final isApproved = rec.isApproved;
    final isRejected = rec.isRejected;
    final isPending = rec.isPending;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isApproved
              ? const Color(0xFFBBF246)
              : isRejected
              ? const Color(0xFFE5E5E5)
              : const Color(0xFFE5E5E5),
          width: isApproved ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isApproved
                            ? const Color(0xFFBBF246).withValues(alpha: 0.3)
                            : const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        RekomendasiAiController.categoryLabel(rec.category),
                        style: const TextStyle(
                          color: Color(0xFF47464B),
                          fontSize: 12,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: Color(0xFF77767B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          RekomendasiAiController.durationLabel(
                            rec.durationMinutes,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF77767B),
                            fontSize: 12,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  rec.activityName,
                  style: const TextStyle(
                    color: Color(0xFF1C1B1C),
                    fontSize: 18,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (rec.frequencySuggestion != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.repeat,
                        size: 14,
                        color: Color(0xFF77767B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rec.frequencySuggestion!,
                        style: const TextStyle(
                          color: Color(0xFF77767B),
                          fontSize: 12,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  rec.displayReason,
                  style: const TextStyle(
                    color: Color(0xFF47464B),
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    height: 1.5,
                  ),
                ),
                if (!isPending) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isApproved
                          ? const Color(0xFFBBF246).withValues(alpha: 0.2)
                          : const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      RekomendasiAiController.statusLabel(status),
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                        color: isApproved
                            ? const Color(0xFF192126)
                            : const Color(0xFF77767B),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isPending)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFF5F5F4), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => controller.approveRecommendation(rec),
                      icon: const Icon(
                        Icons.add_task,
                        color: Color(0xFF192126),
                        size: 18,
                      ),
                      label: const Text(
                        'Tambahkan ke Jadwal',
                        style: TextStyle(
                          color: Color(0xFF192126),
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: const Color(0xFFF5F5F4),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => controller.rejectRecommendation(rec),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF77767B),
                        size: 18,
                      ),
                      label: const Text(
                        'Tolak',
                        style: TextStyle(
                          color: Color(0xFF77767B),
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
