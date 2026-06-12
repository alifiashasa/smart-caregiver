import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/elderly_repository.dart';
import '../../../routes/app_pages.dart';

class ProfilLansiaController extends GetxController {
  final ElderlyRepository _elderlyRepository;

  ProfilLansiaController({required ElderlyRepository elderlyRepository})
      : _elderlyRepository = elderlyRepository;

  // ── Reactive state ──
  final _currentIndex = 3.obs;
  final _patientImage = 'assets/images/patient_ibu_siti.png'.obs;
  final _isLoading = false.obs;

  // ── Form controllers ──
  final namaController = TextEditingController();
  final umurController = TextEditingController();
  final jenisKelaminController = TextEditingController();
  final riwayatMedisController = TextEditingController();
  final minatHobiController = TextEditingController();

  // ── Public getters ──
  int get currentIndex => _currentIndex.value;
  String get patientImage => _patientImage.value;
  bool get isLoading => _isLoading.value;

  set currentIndex(int value) => _currentIndex.value = value;

  String? _elderlyId;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      _elderlyId = args['elderly_id']?.toString();

      if (args['from'] != null) {
        _currentIndex.value = args['from'];
      }

      namaController.text = args['name'] ?? 'Ibu Siti';
      umurController.text =
          (args['age']?.toString() ?? '55').replaceAll(' Tahun', '');
      jenisKelaminController.text = args['gender'] ?? 'Perempuan';
      _patientImage.value =
          args['image'] ?? 'assets/images/patient_ibu_siti.png';
    } else {
      namaController.text = 'Ibu Siti';
      umurController.text = '55';
      jenisKelaminController.text = 'Perempuan';
    }

    if (_elderlyId != null) {
      loadProfile(_elderlyId!);
    }
  }

  Future<void> loadProfile(String id) async {
    _isLoading.value = true;

    final result = await _elderlyRepository.getById(id);

    _isLoading.value = false;

    if (result['error'] == true) return;

    final data = result['data'] as Map<String, dynamic>?;
    if (data != null) {
      namaController.text = data['full_name'] ?? namaController.text;
      umurController.text = data['age']?.toString() ?? umurController.text;
      jenisKelaminController.text =
          data['gender'] ?? jenisKelaminController.text;
      riwayatMedisController.text = data['medical_history'] ?? '';
      minatHobiController.text = data['hobbies_interests'] ?? '';
      if (data['photo_url'] != null &&
          data['photo_url'].toString().isNotEmpty) {
        _patientImage.value = data['photo_url'];
      }
    }
  }

  void changePage(int index) {
    if (_currentIndex.value == index) return;

    int previousIndex = _currentIndex.value;
    _currentIndex.value = index;

    final args = {
      'from': previousIndex,
      'name': namaController.text,
      'age': umurController.text,
      'image': _patientImage.value,
      'gender': jenisKelaminController.text,
      if (_elderlyId != null) 'elderly_id': _elderlyId,
    };

    if (index == 0) {
      Get.offNamed(Routes.DASHBOARD, arguments: args);
    } else if (index == 1) {
      Get.offNamed(Routes.CALENDAR, arguments: args);
    } else if (index == 2) {
      Get.offNamed(Routes.PATIENT_DETAIL, arguments: args);
    } else if (index == 3) {
      Get.offNamed(Routes.PROFIL_LANSIA, arguments: args);
    }
  }

  Future<void> saveChanges() async {
    if (_elderlyId == null) {
      Get.snackbar('Info', 'Tidak ada profil lansia yang dimuat');
      return;
    }

    _isLoading.value = true;

    final age = int.tryParse(umurController.text);

    final result = await _elderlyRepository.update(
      _elderlyId!,
      fullName:
          namaController.text.isNotEmpty ? namaController.text : null,
      age: age,
      gender: jenisKelaminController.text.isNotEmpty
          ? jenisKelaminController.text
          : null,
      medicalHistory: riwayatMedisController.text.isNotEmpty
          ? riwayatMedisController.text
          : null,
      hobbiesInterests: minatHobiController.text.isNotEmpty
          ? minatHobiController.text
          : null,
    );

    _isLoading.value = false;

    if (result['error'] == true) {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Gagal menyimpan perubahan',
      );
      return;
    }

    Get.snackbar(
      'Berhasil',
      'Data profil berhasil diperbarui',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFBBF246),
      colorText: const Color(0xFF192126),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Color(0xFF192126)),
    );
  }

  @override
  void onReady() {
    super.onReady();
    if (_currentIndex.value != 3) {
      Future.delayed(const Duration(milliseconds: 10), () {
        _currentIndex.value = 3;
      });
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    umurController.dispose();
    jenisKelaminController.dispose();
    riwayatMedisController.dispose();
    minatHobiController.dispose();
    super.onClose();
  }
}
