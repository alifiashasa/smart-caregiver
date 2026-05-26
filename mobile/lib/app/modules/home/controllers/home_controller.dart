import 'package:get/get.dart';
import '../../../data/dashboard_api.dart';
import '../../../data/notification_api.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final elderlyList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final unreadCount = 0.obs;

  final DashboardApi _dashboardApi = DashboardApi();
  final NotificationApi _notificationApi = NotificationApi();

  @override
  void onInit() {
    super.onInit();
    loadElderly();
    loadUnreadCount();
  }

  Future<void> loadElderly() async {
    isLoading.value = true;

    final result = await _dashboardApi.getOverview();

    isLoading.value = false;

    if (result['error'] == true) {
      return;
    }

    final data = result['data'];
    if (data != null) {
      final elderly = data['elderly'] as List<dynamic>?;
      if (elderly != null) {
        elderlyList.value = elderly.cast<Map<String, dynamic>>();
      }
    }
  }

  Future<void> loadUnreadCount() async {
    final result = await _notificationApi.getUnreadCount();

    if (!result['error'] && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      unreadCount.value = data['unread_count'] as int? ?? 0;
    }
  }

  /// Count elderly that need attention (critical/needs_attention status)
  int get needsAttentionCount {
    return elderlyList.where((e) {
      final status = (e['latest_health_status'] as String?) ?? '';
      return status == 'critical' || status == 'needs_attention';
    }).length;
  }

  void navigateToDashboard(Map<String, dynamic> elderly) {
    final name = elderly['full_name'] as String? ?? '';
    final age = elderly['age'];
    final gender = elderly['gender'] as String? ?? 'Laki-laki';
    final elderlyId = elderly['elderly_id'];

    Get.toNamed(
      Routes.DASHBOARD,
      arguments: {
        'name': name,
        'age': age?.toString() ?? '',
        'gender': gender,
        'elderly_id': elderlyId is int
            ? elderlyId
            : int.tryParse(elderlyId?.toString() ?? '') ?? 0,
        'image': 'assets/images/patient_ibu_siti.png',
      },
    );
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