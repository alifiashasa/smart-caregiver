import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/dashboard/views/dashboard_view.dart';
import 'package:mobile/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';

Widget createTestWidget() {
  Get.put(DashboardController());
  return const MaterialApp(
    home: DashboardView(),
  );
}

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('DashboardView should render', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byType(DashboardView), findsOneWidget);
  });
}
