import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF192126)),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        'Dianalisis dari data kesehatan dan aktivitas kemarin',
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
                const SizedBox(height: 24),
                ...controller.recommendations.map((rec) => _buildAiCard(rec)),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAiCard(Map<String, dynamic> rec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
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
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        rec['type'],
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
                          rec['duration'],
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
                  rec['title'],
                  style: const TextStyle(
                    color: Color(0xFF1C1B1C),
                    fontSize: 18,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  rec['reason'],
                  style: const TextStyle(
                    color: Color(0xFF47464B),
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFF5F5F4), width: 1),
              ),
            ),
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
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
