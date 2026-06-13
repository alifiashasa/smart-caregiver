import '../../core/api_result.dart';
import '../dashboard_api.dart';
import '../elderly_api.dart';
import '../health_api.dart';
import '../models/dashboard_elderly_model.dart';

class DashboardRepository {
  final DashboardApi _dashboardApi;
  final ElderlyApi _elderlyApi;
  final HealthApi _healthApi;

  DashboardRepository()
    : _dashboardApi = DashboardApi(),
      _elderlyApi = ElderlyApi(),
      _healthApi = HealthApi();

  Future<Map<String, dynamic>> getOverview() => _dashboardApi.getOverview();

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
