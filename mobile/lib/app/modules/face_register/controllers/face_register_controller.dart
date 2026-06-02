import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/app/data/auth_face_api.dart';
import 'package:mobile/app/routes/app_pages.dart';

class FaceRegisterController extends GetxController {
  final AuthFaceApi _faceApi = AuthFaceApi();
  final isLoading = false.obs;
  final isRegistered = false.obs;
  final capturedImageBytes = Rx<Uint8List?>(null);
  final errorMessage = ''.obs;

  Future<void> setImage(XFile file) async {
    capturedImageBytes.value = await file.readAsBytes();
    errorMessage.value = '';
  }

  void clearImage() {
    capturedImageBytes.value = null;
    errorMessage.value = '';
  }

  Future<void> registerFace() async {
    final imageBytes = capturedImageBytes.value;
    if (imageBytes == null) {
      errorMessage.value = 'Ambil foto wajah terlebih dahulu';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _faceApi.registerFace(imageBytes: imageBytes);

      if (result['error'] == true) {
        errorMessage.value = result['message'] ?? 'Gagal mendaftarkan wajah';
        isLoading.value = false;
        return;
      }

      isRegistered.value = true;
      Get.snackbar(
        'Berhasil',
        'Wajah berhasil didaftarkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: const Color(0xFF192126),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
    }

    isLoading.value = false;
  }

  void skipAndGoToLogin() {
    Get.offNamed(Routes.LOGIN);
  }
}
