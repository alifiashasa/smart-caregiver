import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Sets up GetX test mode and registers common mocks.
/// Call this in setUp() of each test file.
void setupGetXTest() {
  Get.testMode = true;
}

/// Cleans up GetX after a test.
/// Call this in tearDown() of each test file.
void teardownGetXTest() {
  Get.reset();
}

/// A simple mock for ImagePicker used in TambahLansiaController tests.
class MockImagePicker {
  Future<String?> pickImage() async {
    return '/mock/path/image.jpg';
  }
}

/// Helper to create a mock snapshot for widget tests.
MaterialApp createTestApp(Widget home) {
  return MaterialApp(
    home: home,
    routes: {
      '/login': (_) => const Scaffold(body: Text('Login Screen')),
      '/home': (_) => const Scaffold(body: Text('Home Screen')),
      '/dashboard': (_) => const Scaffold(body: Text('Dashboard Screen')),
      '/calendar': (_) => const Scaffold(body: Text('Calendar Screen')),
      '/patient-detail': (_) => const Scaffold(body: Text('Patient Detail Screen')),
      '/profil-lansia': (_) => const Scaffold(body: Text('Profil Lansia Screen')),
      '/register': (_) => const Scaffold(body: Text('Register Screen')),
      '/success-log-kesehatan': (_) => const Scaffold(body: Text('Success Screen')),
      '/log-kesehatan': (_) => const Scaffold(body: Text('Log Kesehatan Screen')),
    },
  );
}
