import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/app/data/auth_face_api.dart';
import 'package:mobile/app/routes/app_pages.dart';

class FaceVerifyController extends GetxController {
  final AuthFaceApi _faceApi = AuthFaceApi();
  final isLoading = false.obs;
  final isVerified = false.obs;
  final capturedImageBytes = Rx<Uint8List?>(null);
  final errorMessage = ''.obs;
  final similarity = 0.0.obs;

  Future<void> setImage(XFile file) async {
    capturedImageBytes.value = await file.readAsBytes();
    errorMessage.value = '';
  }

  void clearImage() {
    capturedImageBytes.value = null;
    errorMessage.value = '';
  }

  Future<void> verifyFace() async {
    final imageBytes = capturedImageBytes.value;
    if (imageBytes == null) {
      errorMessage.value = 'Ambil foto wajah terlebih dahulu';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _faceApi.verifyFace(imageBytes: imageBytes);

      if (result['error'] == true) {
        errorMessage.value = result['message'] ?? 'Verifikasi wajah gagal';
        isLoading.value = false;
        return;
      }

      final data = result['data'] as Map<String, dynamic>;
      final success = data['success'] == true;
      similarity.value = (data['similarity'] ?? 0.0).toDouble();

      if (success) {
        isVerified.value = true;
        Get.snackbar(
          'Berhasil',
          'Wajah terverifikasi!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: const Color(0xFF192126),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );

        // Small delay so user sees the success message
        await Future.delayed(const Duration(milliseconds: 800));
        Get.offAllNamed(Routes.HOME);
      } else {
        errorMessage.value =
            'Wajah tidak cocok (similarity: ${(similarity.value * 100).toStringAsFixed(0)}%). Coba lagi atau lewati.';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
    }

    isLoading.value = false;
  }

  void skipAndGoToHome() {
    Get.offAllNamed(Routes.HOME);
  }
}
