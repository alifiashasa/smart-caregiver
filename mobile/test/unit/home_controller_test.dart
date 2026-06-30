import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/home/controllers/home_controller.dart';
import '../test_helpers.dart';

void main() {
  late HomeController controller;
  late MockDashboardRepository mockDashboardRepository;
  late MockNotificationRepository mockNotificationRepository;

  setUp(() {
    mockDashboardRepository = MockDashboardRepository();
    mockNotificationRepository = MockNotificationRepository();
    stubHomeControllerDeps(mockDashboardRepository, mockNotificationRepository);
    Get.testMode = true;
    controller = HomeController(
      dashboardRepository: mockDashboardRepository,
      notificationRepository: mockNotificationRepository,
    );
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  test('initial elderly list should be empty', () {
    expect(controller.elderlyList.length, 0);
  });

  test('initial isLoading should be false', () {
    expect(controller.isLoading, false);
  });
}
