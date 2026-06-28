import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/register/views/register_view.dart';
import 'package:mobile/app/modules/register/controllers/register_controller.dart';
import 'package:flutter/material.dart';

Widget createTestWidget() {
  Get.put(RegisterController());
  return const MaterialApp(
    home: RegisterView(),
  );
}

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('RegisterView should render', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byType(RegisterView), findsOneWidget);
  });
}
