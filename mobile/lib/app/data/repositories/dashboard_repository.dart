import 'package:get_storage/get_storage.dart';

import '../../core/api_result.dart';
import '../dashboard_api.dart';
import '../elderly_api.dart';
import '../health_api.dart';
import '../models/dashboard_elderly_model.dart';

class DashboardRepository {
  static const _overviewCacheKey = 'dashboard_overview_cache';

  final DashboardApi _dashboardApi;
  final ElderlyApi _elderlyApi;
  final HealthApi _healthApi;
  final GetStorage _cache = GetStorage();

  DashboardRepository()
    : _dashboardApi = DashboardApi(),
      _elderlyApi = ElderlyApi(),
      _healthApi = HealthApi();

  Future<Map<String, dynamic>> getOverview() => _dashboardApi.getOverview();

  List<DashboardElderlyModel> getCachedOverviewItems() {
    final raw = _cache.read<List<dynamic>>(_overviewCacheKey);
    if (raw == null) return const [];

    return raw
        .whereType<Map>()
        .map(
          (item) =>
              DashboardElderlyModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  Future<void> cacheOverviewItems(List<DashboardElderlyModel> elderly) async {
    await _cache.write(
      _overviewCacheKey,
      elderly.map((item) => item.toJson()).toList(),
    );
  }

  Future<ApiResult<List<DashboardElderlyModel>>> getOverviewItems() async {
    final response = await _dashboardApi.getOverview();
    final result = response.toApiResult();

    return result.when(
      success: (data) {
        final rawList = data['elderly'] as List<dynamic>? ?? [];
        final elderly = rawList
            .whereType<Map>()
            .map(
              (item) => DashboardElderlyModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
        cacheOverviewItems(elderly);
        return ApiResult.success(elderly);
      },
      failure: (failure) => ApiResult.failure(
        failure.message,
        statusCode: failure.statusCode,
        sessionExpired: failure.sessionExpired,
        detailBody: failure.detailBody,
      ),
    );
  }

  Future<Map<String, dynamic>> getTrends(
    String elderlyId, {
    String range = '7d',
  }) => _dashboardApi.getTrends(elderlyId, range: range);

  Future<Map<String, dynamic>> getElderlyProfile(String id) =>
      _elderlyApi.getById(id);

  Future<Map<String, dynamic>> getLatestHealthRecord(
    String elderlyId, {
    int? limit,
  }) => _healthApi.getRecords(elderlyId, limit: limit);
}
