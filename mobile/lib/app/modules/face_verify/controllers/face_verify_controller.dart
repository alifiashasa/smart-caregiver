import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/app/data/repositories/auth_repository.dart';
import 'package:mobile/app/routes/app_pages.dart';

class FaceVerifyController extends GetxController {
  final AuthRepository _authRepository;

  FaceVerifyController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  // ── Reactive state ──
  final _isLoading = false.obs;
  final _isVerified = false.obs;
  final _capturedImageBytes = Rx<Uint8List?>(null);
  final _errorMessage = ''.obs;
  final _similarity = 0.0.obs;

  // ── Public getters ──
  bool get isLoading => _isLoading.value;
  bool get isVerified => _isVerified.value;
  Uint8List? get capturedImageBytes => _capturedImageBytes.value;
  String get errorMessage => _errorMessage.value;
  double get similarity => _similarity.value;

  Future<void> setImage(XFile file) async {
    _capturedImageBytes.value = await file.readAsBytes();
    _errorMessage.value = '';
  }

  void clearImage() {
    _capturedImageBytes.value = null;
    _errorMessage.value = '';
  }

  Future<void> verifyFace() async {
    final imageBytes = _capturedImageBytes.value;
    if (imageBytes == null) {
      _errorMessage.value = 'Ambil foto wajah terlebih dahulu';
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final result = await _authRepository.verifyFace(imageBytes: imageBytes);

      if (result['error'] == true) {
        _errorMessage.value =
            result['message'] ?? 'Verifikasi wajah gagal';
        _isLoading.value = false;
        return;
      }

      final data = result['data'] as Map<String, dynamic>;
      final success = data['success'] == true;
      _similarity.value = (data['similarity'] ?? 0.0).toDouble();

      if (success) {
        _isVerified.value = true;
        Get.snackbar(
          'Berhasil',
          'Wajah terverifikasi!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: const Color(0xFF192126),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );

        await Future.delayed(const Duration(milliseconds: 800));
        Get.offAllNamed(Routes.HOME);
      } else {
        _errorMessage.value =
            'Wajah tidak cocok (similarity: ${(_similarity.value * 100).toStringAsFixed(0)}%). Coba lagi atau lewati.';
      }
    } catch (e) {
      _errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading.value = false;
  }

  void skipAndGoToHome() {
    Get.offAllNamed(Routes.HOME);
  }
}
