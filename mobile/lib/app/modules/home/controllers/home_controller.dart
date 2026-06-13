import 'package:get/get.dart';
import '../../../core/logger.dart';
import '../../../data/models/dashboard_elderly_model.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final DashboardRepository _dashboardRepository;
  final NotificationRepository _notificationRepository;

  HomeController({
    required DashboardRepository dashboardRepository,
    required NotificationRepository notificationRepository,
  }) : _dashboardRepository = dashboardRepository,
       _notificationRepository = notificationRepository;

  // ── Reactive state ──
  final _elderlyList = <DashboardElderlyModel>[].obs;
  final _isLoading = false.obs;
  final _unreadCount = 0.obs;

  // ── Public getters ──
  List<DashboardElderlyModel> get elderlyList => _elderlyList;
  bool get isLoading => _isLoading.value;
  int get unreadCount => _unreadCount.value;

  @override
  void onInit() {
    super.onInit();
    loadElderly();
    loadUnreadCount();
  }

  Future<void> loadElderly() async {
    _isLoading.value = true;

    final result = await _dashboardRepository.getOverviewItems();

    _isLoading.value = false;

    result.when(
      success: (elderly) {
        log.info('loadElderly sukses', data: {'count': elderly.length});
        _elderlyList.value = elderly;
      },
      failure: (failure) {
        log.error(
          'loadElderly gagal',
          data: {'message': failure.message, 'statusCode': failure.statusCode},
        );
        if (failure.sessionExpired) {
          Get.offAllNamed(Routes.LOGIN);
        }
      },
    );
  }

  Future<void> loadUnreadCount() async {
    final result = await _notificationRepository.getUnreadCount();

    if (!result['error'] && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      _unreadCount.value = data['unread_count'] as int? ?? 0;
    }
  }

  /// Count elderly that need attention (critical/needs_attention status)
  int get needsAttentionCount {
    return _elderlyList.where((elderly) => elderly.needsAttention).length;
  }

  Future<void> navigateToDashboard(DashboardElderlyModel elderly) async {
    await Get.toNamed(Routes.DASHBOARD, arguments: elderly.toRouteArguments());

    loadElderly();
    loadUnreadCount();
  }

  /// Human-readable status label
  static String statusLabel(String? status) {
    switch (status) {
      case 'normal':
        return 'NORMAL';
      case 'warning':
        return 'WASPADA';
      case 'needs_attention':
        return 'PERHATIAN';
      case 'critical':
        return 'KRITIS';
      default:
        return 'NORMAL';
    }
  }

  static bool isCritical(String? status) {
    return status == 'critical' || status == 'needs_attention';
  }
}
