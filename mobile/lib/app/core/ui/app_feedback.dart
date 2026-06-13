import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppFeedback {
  const AppFeedback._();

  static void success(String title, String message) {
    _show(
      title,
      message,
      backgroundColor: const Color(0xFFBBF246),
      textColor: const Color(0xFF192126),
    );
  }

  static void error(String title, String message) {
    _show(
      title,
      message,
      backgroundColor: Colors.red.shade100,
      textColor: const Color(0xFF192126),
    );
  }

  static void warning(String title, String message) {
    _show(
      title,
      message,
      backgroundColor: const Color(0xFFFFF3CD),
      textColor: const Color(0xFF192126),
    );
  }

  static void info(String title, String message) {
    _show(
      title,
      message,
      backgroundColor: const Color(0xFFE3E1EC),
      textColor: const Color(0xFF192126),
    );
  }

  static void _show(
    String title,
    String message, {
    required Color backgroundColor,
    required Color textColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: textColor,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}
