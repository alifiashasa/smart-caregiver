import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/home/controllers/home_controller.dart';

void main() {
  late HomeController controller;

  setUp(() {
    Get.testMode = true;
    controller = HomeController();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  test('initial count should be 0', () {
    expect(controller.count.value, 0);
  });

  test('increment should increase count by 1', () {
    controller.increment();
    expect(controller.count.value, 1);
  });

  test('increment should work multiple times', () {
    controller.increment();
    controller.increment();
    controller.increment();
    expect(controller.count.value, 3);
  });
}
