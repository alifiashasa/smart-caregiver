import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/ai_api.dart';

class RekomendasiAiController extends GetxController {
  final AiApi _api = AiApi();

  final recommendations = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final isGenerating = false.obs;
  final errorMessage = Rxn<String>();

  final elderlyId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _readArgs();
  }

  void _readArgs() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['elderly_id'] is int) {
        elderlyId.value = args['elderly_id'];
      } else if (args['elderly_id'] != null) {
        elderlyId.value =
            int.tryParse(args['elderly_id'].toString()) ?? 0;
      }
    }
    if (elderlyId.value > 0) {
      fetchRecommendations();
    } else {
      isLoading.value = false;
      errorMessage.value = 'Data lansia tidak ditemukan.';
    }
  }

  Future<void> fetchRecommendations() async {
    if (elderlyId.value <= 0) return;

    isLoading.value = true;
    errorMessage.value = null;

    final result = await _api.getRecommendations(elderlyId.value);

    if (!result['error'] && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      final rawList = data['recommendations'] as List<dynamic>? ?? [];
      recommendations.assignAll(rawList.cast<Map<String, dynamic>>());
    } else {
      errorMessage.value =
          result['message'] ?? 'Gagal memuat rekomendasi.';
    }

    isLoading.value = false;
  }

  Future<void> generateRecommendation({String? additionalContext}) async {
    if (elderlyId.value <= 0) return;

    isGenerating.value = true;
    errorMessage.value = null;

    final result = await _api.generateRecommendation(
      elderlyId: elderlyId.value,
      additionalContext: additionalContext,
    );

    isGenerating.value = false;

    if (!result['error']) {
      Get.snackbar(
        'Rekomendasi Baru',
        'Rekomendasi AI berhasil dibuat',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFBBF246),
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      await fetchRecommendations();
    } else {
      Get.snackbar(
        'Gagal Generate',
        result['message'] ?? 'Terjadi kesalahan. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> approveRecommendation(Map<String, dynamic> rec) async {
    final id = rec['id']?.toString();
    if (id == null || id.isEmpty) return;

    // Default schedule for 1 hour from now
    final scheduledAt = DateTime.now().add(const Duration(hours: 1)).toIso8601String();
    final duration = rec['duration_minutes'] as int? ?? 30;

    final result = await _api.approveRecommendation(
      elderlyId: elderlyId.value,
      recommendationId: id,
      scheduledAt: scheduledAt,
      durationMinutes: duration,
      reminderMinutes: const [10, 30],
    );

    if (!result['error']) {
      // Update local state
      final index = recommendations.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        recommendations[index]['status'] = 'approved';
        recommendations.refresh();
      }

      Get.snackbar(
        'Ditambahkan ke Jadwal',
        '${rec['activity_name']} berhasil ditambahkan ke jadwal',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFBBF246),
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      Get.snackbar(
        'Gagal',
        result['message'] ?? 'Gagal menyetujui rekomendasi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> rejectRecommendation(Map<String, dynamic> rec) async {
    final id = rec['id']?.toString();
    if (id == null || id.isEmpty) return;

    final result = await _api.rejectRecommendation(
      elderlyId: elderlyId.value,
      recommendationId: id,
    );

    if (!result['error']) {
      final index = recommendations.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        recommendations[index]['status'] = 'rejected';
        recommendations.refresh();
      }

      Get.snackbar(
        'Ditolak',
        '${rec['activity_name']} tidak ditambahkan ke jadwal',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF2F2F2),
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      Get.snackbar(
        'Gagal',
        result['message'] ?? 'Gagal menolak rekomendasi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  /// Human-readable label for server enum category
  static String categoryLabel(String? category) {
    switch (category) {
      case 'physical':
        return 'Fisik';
      case 'cognitive':
        return 'Kognitif';
      case 'social':
        return 'Sosial';
      case 'creative':
        return 'Kreatif';
      case 'relaxation':
        return 'Relaksasi';
      case 'nature':
        return 'Alam';
      case 'music':
        return 'Musik';
      default:
        return category ?? 'Umum';
    }
  }

  /// Duration display text
  static String durationLabel(dynamic minutes) {
    if (minutes == null) return '—';
    final m = minutes is int ? minutes : int.tryParse(minutes.toString());
    if (m == null) return '—';
    if (m >= 60) {
      final h = m ~/ 60;
      final rem = m % 60;
      return rem > 0 ? '$h jam $rem menit' : '$h jam';
    }
    return '$m menit';
  }

  /// Status label in Indonesian
  static String statusLabel(String? status) {
    switch (status) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }
}
