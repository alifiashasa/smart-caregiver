import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/success_log_kesehatan/views/success_log_kesehatan_view.dart';
import 'package:mobile/app/modules/success_log_kesehatan/controllers/success_log_kesehatan_controller.dart';
import 'package:flutter/material.dart';

Widget createTestWidget() {
  Get.put(SuccessLogKesehatanController());
  return const MaterialApp(
    home: SuccessLogKesehatanView(),
  );
}

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('SuccessLogKesehatanView should render', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byType(SuccessLogKesehatanView), findsOneWidget);
  });
}
