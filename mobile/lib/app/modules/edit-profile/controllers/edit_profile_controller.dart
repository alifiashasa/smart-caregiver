import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/logger.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class EditProfileController extends GetxController {
  final AuthRepository _authRepository;

  EditProfileController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final _isLoading = false.obs;
  final _isSaving = false.obs;
  final _initialName = ''.obs;
  final _initialPhone = ''.obs;

  bool get isLoading => _isLoading.value;
  bool get isSaving => _isSaving.value;

  bool get hasChanges =>
      nameController.text.trim() != _initialName.value ||
      phoneController.text.trim() != _initialPhone.value;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> _loadProfile() async {
    _isLoading.value = true;

    final result = await _authRepository.getCurrentUser();

    result.when(
      success: (user) {
        nameController.text = user.fullName;
        phoneController.text = user.phone ?? '';
        _initialName.value = user.fullName;
        _initialPhone.value = user.phone ?? '';
      },
      failure: (failure) {
        log.error('Gagal load profil', data: {
          'message': failure.message,
          'statusCode': failure.statusCode,
        });
        if (failure.sessionExpired) {
          Get.offAllNamed(Routes.LOGIN);
        }
      },
    );

    _isLoading.value = false;
  }

  Future<void> save() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Nama diperlukan',
        'Nama lengkap tidak boleh kosong.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _isSaving.value = true;

    final result = await _authRepository.updateProfile(
      fullName: name != _initialName.value ? name : null,
      phone: phoneController.text.trim() != _initialPhone.value
          ? phoneController.text.trim()
          : null,
    );

    _isSaving.value = false;

    result.when(
      success: (_) {
        Get.back(result: true);
      },
      failure: (failure) {
        log.error('Gagal simpan profil', data: {
          'message': failure.message,
          'statusCode': failure.statusCode,
        });
        Get.snackbar(
          'Gagal menyimpan',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        if (failure.sessionExpired) {
          Get.offAllNamed(Routes.LOGIN);
        }
      },
    );
  }
}
