import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/app/data/repositories/auth_repository.dart';
import 'package:mobile/app/routes/app_pages.dart';

class FaceRegisterController extends GetxController {
  final AuthRepository _authRepository;

  FaceRegisterController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  // ── Reactive state ──
  final _isLoading = false.obs;
  final _isRegistered = false.obs;
  final _capturedImageBytes = Rx<Uint8List?>(null);
  final _errorMessage = ''.obs;

  // ── Public getters ──
  bool get isLoading => _isLoading.value;
  bool get isRegistered => _isRegistered.value;
  Uint8List? get capturedImageBytes => _capturedImageBytes.value;
  String get errorMessage => _errorMessage.value;

  Future<void> setImage(XFile file) async {
    _capturedImageBytes.value = await file.readAsBytes();
    _errorMessage.value = '';
  }

  void clearImage() {
    _capturedImageBytes.value = null;
    _errorMessage.value = '';
  }

  Future<void> registerFace() async {
    final imageBytes = _capturedImageBytes.value;
    if (imageBytes == null) {
      _errorMessage.value = 'Ambil foto wajah terlebih dahulu';
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final result = await _authRepository.registerFace(imageBytes: imageBytes);

      if (result['error'] == true) {
        _errorMessage.value = result['message'] ?? 'Gagal mendaftarkan wajah';
        _isLoading.value = false;
        return;
      }

      _isRegistered.value = true;
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
      _errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading.value = false;
  }

  void skipAndGoToLogin() {
    Get.offNamed(Routes.LOGIN);
  }
}
