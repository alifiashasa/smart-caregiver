import 'package:get/get.dart';
import '../../../core/logger.dart';
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
  final _elderlyList = <Map<String, dynamic>>[].obs;
  final _isLoading = false.obs;
  final _unreadCount = 0.obs;

  // ── Public getters ──
  List<Map<String, dynamic>> get elderlyList => _elderlyList;
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

    final result = await _dashboardRepository.getOverview();

    _isLoading.value = false;

    if (result['error'] == true) {
      log.error(
        'loadElderly gagal',
        data: {
          'message': result['message'],
          'statusCode': result['statusCode'],
        },
      );
      if (result['session_expired'] == true) {
        Get.offAllNamed(Routes.LOGIN);
      }
      return;
    }

    final data = result['data'];
    if (data != null) {
      final elderly = data['elderly'] as List<dynamic>?;
      if (elderly != null) {
        log.info('loadElderly sukses', data: {'count': elderly.length});
        _elderlyList.value = elderly.cast<Map<String, dynamic>>();
      } else {
        log.warn(
          'loadElderly: field "elderly" tidak ditemukan di response',
          data: {'response': data},
        );
      }
    } else {
      log.warn('loadElderly: result["data"] null');
    }
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
    return _elderlyList.where((e) {
      final status = (e['latest_health_status'] as String?) ?? '';
      return status == 'critical' || status == 'needs_attention';
    }).length;
  }

  Future<void> navigateToDashboard(Map<String, dynamic> elderly) async {
    final name = elderly['full_name'] as String? ?? '';
    final age = elderly['age'];
    final gender = elderly['gender'] as String? ?? 'Laki-laki';
    final elderlyId = elderly['elderly_id']?.toString() ?? '';

    await Get.toNamed(
      Routes.DASHBOARD,
      arguments: {
        'name': name,
        'age': age?.toString() ?? '',
        'gender': gender,
        'elderly_id': elderlyId,
        'image': 'assets/images/patient_ibu_siti.png',
      },
    );

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
