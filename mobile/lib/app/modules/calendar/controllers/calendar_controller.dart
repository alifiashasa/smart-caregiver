import 'package:get/get.dart';

class CalendarController extends GetxController {
  //TODO: Implement CalendarController

  final currentIndex = 1.obs;

  void changePage(int index) {
    if (currentIndex.value == index) return;
    
    int previousIndex = currentIndex.value;
    currentIndex.value = index;
    
    if (index == 0) {
      Get.offNamed('/dashboard', arguments: {'from': previousIndex});
    } else if (index == 1) {
      Get.offNamed('/calendar', arguments: {'from': previousIndex});
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map && Get.arguments['from'] != null) {
      currentIndex.value = Get.arguments['from'];
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (currentIndex.value != 1) {
      Future.delayed(const Duration(milliseconds: 10), () {
        currentIndex.value = 1;
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
