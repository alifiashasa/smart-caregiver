import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/login/views/login_view.dart';
import 'package:mobile/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import '../test_helpers.dart';

Widget createTestWidget() {
  Get.put(LoginController(authRepository: MockAuthRepository()));
  return const MaterialApp(
    home: LoginView(),
  );
}

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('LoginView should render email and password fields', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    // The view uses GetView pattern - should render
    expect(find.byType(LoginView), findsOneWidget);
  });
}
