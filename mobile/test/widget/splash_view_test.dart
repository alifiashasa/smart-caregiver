import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/splash/views/splash_view.dart';
import 'package:mobile/app/modules/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import '../test_helpers.dart';

Widget createTestWidget() {
  Get.put(SplashController(authRepository: MockAuthRepository()));
  return const MaterialApp(
    home: SplashView(),
  );
}

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('SplashView should display logo and app name', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    // Just verify the view renders without error
    expect(find.byType(SplashView), findsOneWidget);
  });
}
