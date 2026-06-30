import 'package:mocktail/mocktail.dart';
import 'package:mobile/app/core/api_result.dart';
import 'package:mobile/app/data/repositories/dashboard_repository.dart';
import 'package:mobile/app/data/repositories/health_repository.dart';
import 'package:mobile/app/data/repositories/auth_repository.dart';
import 'package:mobile/app/data/repositories/elderly_repository.dart';
import 'package:mobile/app/data/repositories/schedule_repository.dart';
import 'package:mobile/app/data/repositories/ai_repository.dart';
import 'package:mobile/app/data/repositories/notification_repository.dart';
import 'package:mobile/app/data/models/notification_model.dart';
import 'package:mobile/app/data/models/schedule_model.dart';
import 'package:mobile/app/data/models/dashboard_elderly_model.dart';
import 'package:mobile/app/data/models/user_model.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

class MockHealthRepository extends Mock implements HealthRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockElderlyRepository extends Mock implements ElderlyRepository {}

class MockScheduleRepository extends Mock implements ScheduleRepository {}

class MockAiRepository extends Mock implements AiRepository {}

class MockNotificationRepository extends Mock implements NotificationRepository {}

/// Sets up default stub returns for HomeController's dependencies.
void stubHomeControllerDeps(
  MockDashboardRepository dashboardRepo,
  MockNotificationRepository notificationRepo,
) {
  // getCachedOverviewItems returns List (non-Future) - Mocktail returns null, which is fine
  when(() => dashboardRepo.getOverviewItems())
      .thenAnswer((_) async => ApiResult.success(<DashboardElderlyModel>[]));
  when(() => dashboardRepo.getCachedOverviewItems())
      .thenReturn(<DashboardElderlyModel>[]);
  when(() => notificationRepo.getUnreadCount())
      .thenAnswer((_) async => {'error': false, 'data': {'unread_count': 0}});
}

/// Sets up default stub returns for NotifikasiController's dependencies.
void stubNotifikasiControllerDeps(
  MockNotificationRepository notificationRepo,
) {
  when(() => notificationRepo.getNotificationItems(
    limit: any(named: 'limit'),
    offset: any(named: 'offset'),
  )).thenAnswer(
    (_) async => ApiResult.success((
      notifications: <NotificationModel>[],
      total: 0,
    )),
  );
  when(() => notificationRepo.getUnreadCount())
      .thenAnswer((_) async => {'error': false, 'data': {'unread_count': 0}});
}

/// Sets up default stub returns for CalendarController's dependencies.
void stubCalendarControllerDeps(
  MockScheduleRepository scheduleRepo,
) {
  when(() => scheduleRepo.getScheduleItems(
    any(),
    scheduleType: any(named: 'scheduleType'),
    isActive: any(named: 'isActive'),
    fromDate: any(named: 'fromDate'),
    toDate: any(named: 'toDate'),
    limit: any(named: 'limit'),
    offset: any(named: 'offset'),
  )).thenAnswer(
    (_) async => ApiResult.success(<ScheduleModel>[]),
  );
}

/// Sets up default stub for ProfilCaregiverController's getCurrentUser.
void stubProfileControllerDeps(
  MockAuthRepository authRepo,
) {
  when(() => authRepo.getCurrentUser()).thenAnswer(
    (_) async => ApiResult.success(UserModel(
      id: 'test-user',
      email: 'test@caregiver.com',
      fullName: 'Test Caregiver',
      isEmailVerified: true,
      hasPassword: true,
      createdAt: DateTime.now(),
    )),
  );
}
