import 'package:get/get.dart';
import '../../../core/ui/app_feedback.dart';
import '../../../data/models/ai_recommendation_model.dart';
import '../../../data/repositories/ai_repository.dart';

class RekomendasiAiController extends GetxController {
  final AiRepository _aiRepository;

  RekomendasiAiController({required AiRepository aiRepository})
    : _aiRepository = aiRepository;

  // ── Reactive state ──
  final _recommendations = <AiRecommendationModel>[].obs;
  final _isLoading = true.obs;
  final _isGenerating = false.obs;
  final _errorMessage = Rxn<String>();
  final _elderlyId = ''.obs;

  // ── Public getters ──
  List<AiRecommendationModel> get recommendations => _recommendations;
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

    final result = await _aiRepository.getRecommendationItems(_elderlyId.value);

    result.when(
      success: (recommendations) => _recommendations.assignAll(recommendations),
      failure: (failure) => _errorMessage.value = failure.message,
    );

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
      AppFeedback.success('Rekomendasi Baru', 'Rekomendasi AI berhasil dibuat');
      await fetchRecommendations();
    } else {
      AppFeedback.error(
        'Gagal Generate',
        result['message'] ?? 'Terjadi kesalahan. Coba lagi.',
      );
    }
  }

  Future<void> approveRecommendation(
    AiRecommendationModel recommendation,
  ) async {
    final id = recommendation.id;
    if (id.isEmpty) return;

    final scheduledAt = DateTime.now()
        .add(const Duration(hours: 1))
        .toIso8601String();

    final result = await _aiRepository.approveRecommendation(
      elderlyId: _elderlyId.value,
      recommendationId: id,
      scheduledAt: scheduledAt,
      durationMinutes: recommendation.scheduleDurationMinutes,
      reminderMinutes: const [10, 30],
    );

    if (!result['error']) {
      final index = _recommendations.indexWhere((item) => item.id == id);
      if (index != -1) {
        _recommendations[index] = _recommendations[index].copyWith(
          status: 'approved',
        );
        _recommendations.refresh();
      }

      AppFeedback.success(
        'Ditambahkan ke Jadwal',
        '${recommendation.activityName} berhasil ditambahkan ke jadwal',
      );
    } else {
      AppFeedback.error(
        'Gagal',
        result['message'] ?? 'Gagal menyetujui rekomendasi.',
      );
    }
  }

  Future<void> rejectRecommendation(
    AiRecommendationModel recommendation,
  ) async {
    final id = recommendation.id;
    if (id.isEmpty) return;

    final result = await _aiRepository.rejectRecommendation(
      elderlyId: _elderlyId.value,
      recommendationId: id,
    );

    if (!result['error']) {
      final index = _recommendations.indexWhere((item) => item.id == id);
      if (index != -1) {
        _recommendations[index] = _recommendations[index].copyWith(
          status: 'rejected',
        );
        _recommendations.refresh();
      }

      AppFeedback.info(
        'Ditolak',
        '${recommendation.activityName} tidak ditambahkan ke jadwal',
      );
    } else {
      AppFeedback.error(
        'Gagal',
        result['message'] ?? 'Gagal menolak rekomendasi.',
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
