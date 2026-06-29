import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/bindings/initial_binding.dart';
import 'app/core/fcm_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/api_client.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await ApiClient.initTokenStorage();

  // Load .env (optional — falls back to defaults in config.dart)
  await dotenv.load(fileName: 'assets/.env', isOptional: true);

  // Initialize Firebase (may not be configured for web)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Initialize FCM (non-blocking — app works without push)
    FcmService().init();
  } catch (e) {
    // Firebase/FCM not available on this platform (e.g. web)
    debugPrint('Firebase init skipped: \$e');
  }

  runApp(
    GetMaterialApp(
      title: 'Smart Caregiver',
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1565C0), // biru kesehatan
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
    ),
  );
}
