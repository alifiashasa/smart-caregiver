import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Navigate to LOGIN after a 3-second delay
    // onReady is called after the view is rendered, which is safer
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.LOGIN);
    });
  }
}
