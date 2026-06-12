import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/ai_repository.dart';

class RekomendasiAiController extends GetxController {
  final AiRepository _aiRepository;

  RekomendasiAiController({required AiRepository aiRepository})
      : _aiRepository = aiRepository;

  // ── Reactive state ──
  final _recommendations = <Map<String, dynamic>>[].obs;
  final _isLoading = true.obs;
  final _isGenerating = false.obs;
  final _errorMessage = Rxn<String>();
  final _elderlyId = ''.obs;

  // ── Public getters ──
  List<Map<String, dynamic>> get recommendations => _recommendations;
  bool get isLoading => _isLoading.value;
  bool get isGenerating => _isGenerating.value;
  String? get errorMessage => _errorMessage.value;
  String get elderlyId => _elderlyId.value;

  @override
  void onInit() {
    super.onInit();
    _readArgs();
  }

  void _readArgs() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['elderly_id'] != null) {
        _elderlyId.value = args['elderly_id'].toString();
      }
    }
    if (_elderlyId.value.isNotEmpty) {
      fetchRecommendations();
    } else {
      _isLoading.value = false;
      _errorMessage.value = 'Data lansia tidak ditemukan.';
    }
  }

  Future<void> fetchRecommendations() async {
    if (_elderlyId.value.isEmpty) return;

    _isLoading.value = true;
    _errorMessage.value = null;

    final result = await _aiRepository.getRecommendations(_elderlyId.value);

    if (!result['error'] && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      final rawList = data['recommendations'] as List<dynamic>? ?? [];
      _recommendations.assignAll(rawList.cast<Map<String, dynamic>>());
    } else {
      _errorMessage.value =
          result['message'] ?? 'Gagal memuat rekomendasi.';
    }

    _isLoading.value = false;
  }

  Future<void> generateRecommendation({String? additionalContext}) async {
    if (_elderlyId.value.isEmpty) return;

    _isGenerating.value = true;
    _errorMessage.value = null;

    final result = await _aiRepository.generateRecommendation(
      elderlyId: _elderlyId.value,
      additionalContext: additionalContext,
    );

    _isGenerating.value = false;

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

    final scheduledAt =
        DateTime.now().add(const Duration(hours: 1)).toIso8601String();
    final duration = rec['duration_minutes'] as int? ?? 30;

    final result = await _aiRepository.approveRecommendation(
      elderlyId: _elderlyId.value,
      recommendationId: id,
      scheduledAt: scheduledAt,
      durationMinutes: duration,
      reminderMinutes: const [10, 30],
    );

    if (!result['error']) {
      final index = _recommendations.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _recommendations[index]['status'] = 'approved';
        _recommendations.refresh();
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

    final result = await _aiRepository.rejectRecommendation(
      elderlyId: _elderlyId.value,
      recommendationId: id,
    );

    if (!result['error']) {
      final index = _recommendations.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _recommendations[index]['status'] = 'rejected';
        _recommendations.refresh();
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
