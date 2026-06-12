import '../dashboard_api.dart';
import '../elderly_api.dart';
import '../health_api.dart';

class DashboardRepository {
  final DashboardApi _dashboardApi;
  final ElderlyApi _elderlyApi;
  final HealthApi _healthApi;

  DashboardRepository()
      : _dashboardApi = DashboardApi(),
        _elderlyApi = ElderlyApi(),
        _healthApi = HealthApi();

  Future<Map<String, dynamic>> getOverview() => _dashboardApi.getOverview();

  Future<Map<String, dynamic>> getTrends(
    String elderlyId, {
    String range = '7d',
  }) =>
      _dashboardApi.getTrends(elderlyId, range: range);

  Future<Map<String, dynamic>> getElderlyProfile(String id) =>
      _elderlyApi.getById(id);

  Future<Map<String, dynamic>> getLatestHealthRecord(String elderlyId,
          {int? limit}) =>
      _healthApi.getRecords(elderlyId, limit: limit);
}
