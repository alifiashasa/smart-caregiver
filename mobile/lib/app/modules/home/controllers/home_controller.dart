import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/formatters/app_formatters.dart';
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

  // ── Search & filter state ──
  final searchController = TextEditingController();
  final _searchQuery = ''.obs;
  final _selectedStatusFilter = Rxn<String>(null);

  // ── Public getters ──
  List<DashboardElderlyModel> get elderlyList => _elderlyList;
  bool get isLoading => _isLoading.value;
  int get unreadCount => _unreadCount.value;
  String get searchQuery => _searchQuery.value;
  String? get selectedStatusFilter => _selectedStatusFilter.value;

  /// Has any filter active (search text or status chip)
  bool get hasActiveFilters =>
      _searchQuery.value.trim().isNotEmpty ||
      _selectedStatusFilter.value != null;

  /// Filtered list based on search query and status filter
  List<DashboardElderlyModel> get filteredElderlyList {
    var list = _elderlyList.toList();

    final statusFilter = _selectedStatusFilter.value;
    if (statusFilter != null) {
      list = list.where((e) => e.latestHealthStatus == statusFilter).toList();
    }

    final query = _searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list
          .where((e) => e.fullName.toLowerCase().contains(query))
          .toList();
    }

    return list;
  }

  /// Available status filter options
  static const statusFilterOptions = <_StatusFilterOption>[
    _StatusFilterOption(label: 'Semua', status: null),
    _StatusFilterOption(label: 'Kritis', status: 'critical'),
    _StatusFilterOption(label: 'Waspada', status: 'warning'),
    _StatusFilterOption(label: 'Perhatian', status: 'needs_attention'),
    _StatusFilterOption(label: 'Normal', status: 'normal'),
  ];

  @override
  void onInit() {
    super.onInit();
    loadElderly();
    loadUnreadCount();

    debounce(
      _searchQuery,
      (_) {},
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Call from search TextField's onChanged
  void onSearchChanged(String value) {
    _searchQuery.value = value;
  }

  /// Call from filter chip tap — toggles the status filter
  void onFilterChanged(String? status) {
    _selectedStatusFilter.value =
        _selectedStatusFilter.value == status ? null : status;
  }

  /// Clear all active filters
  void clearFilters() {
    _searchQuery.value = '';
    _selectedStatusFilter.value = null;
    searchController.clear();
  }

  Future<void> loadElderly() async {
    _isLoading.value = true;

    final cached = _dashboardRepository.getCachedOverviewItems();
    if (cached.isNotEmpty && _elderlyList.isEmpty) {
      _elderlyList.value = cached;
    }

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
    return AppFormatters.healthStatusLabel(status);
  }

  static bool isCritical(String? status) {
    return status == 'critical' || status == 'needs_attention';
  }
}

class _StatusFilterOption {
  const _StatusFilterOption({
    required this.label,
    required this.status,
  });

  final String label;
  final String? status;
}
