import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/elderly_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../patient_shell/controllers/patient_shell_controller.dart';

class ProfilLansiaController extends GetxController {
  final ElderlyRepository _elderlyRepository;

  ProfilLansiaController({required ElderlyRepository elderlyRepository})
    : _elderlyRepository = elderlyRepository;

  // ── Reactive state ──
  final _patientImage = 'assets/images/patient_ibu_siti.png'.obs;
  final _isLoading = false.obs;
  final _selectedProfileTab = 0.obs;
  final _shellWorkers = <Worker>[];

  // ── Form controllers ──
  final namaController = TextEditingController();
  final umurController = TextEditingController();
  final jenisKelaminController = TextEditingController();
  final riwayatMedisController = TextEditingController();
  final minatHobiController = TextEditingController();

  // ── Public getters ──
  String get patientImage => _patientImage.value;
  bool get isLoading => _isLoading.value;
  int get selectedProfileTab => _selectedProfileTab.value;

  void changeProfileTab(int index) {
    if (_selectedProfileTab.value == index) return;
    _selectedProfileTab.value = index;
  }

  String? _elderlyId;

  @override
  void onInit() {
    super.onInit();

    final shell = Get.find<PatientShellController>();
    _elderlyId = shell.elderlyId.value.isNotEmpty
        ? shell.elderlyId.value
        : null;
    namaController.text = shell.patientName.value.isNotEmpty
        ? shell.patientName.value
        : 'Ibu Siti';
    umurController.text = shell.patientAge.value.replaceAll(' Tahun', '');
    jenisKelaminController.text = shell.patientGender.value.isNotEmpty
        ? shell.patientGender.value
        : 'Perempuan';
    _patientImage.value = shell.patientImage.value;
    _bindShellProfile(shell);

    if (_elderlyId != null) {
      loadProfile(_elderlyId!);
    }
  }

  void _bindShellProfile(PatientShellController shell) {
    _shellWorkers.addAll([
      ever(shell.patientName, (value) => namaController.text = value),
      ever(
        shell.patientAge,
        (value) => umurController.text = value.replaceAll(' Tahun', ''),
      ),
      ever(shell.patientGender, (value) => jenisKelaminController.text = value),
      ever(shell.patientImage, (value) => _patientImage.value = value),
    ]);
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
      Get.find<PatientShellController>().updatePatientProfile(
        name: namaController.text,
        age: umurController.text.isNotEmpty
            ? '${umurController.text} Tahun'
            : '',
        gender: jenisKelaminController.text,
        image: _patientImage.value,
      );
    }
  }

  Future<void> saveChanges() async {
    if (_isLoading.value) return;

    if (_elderlyId == null) {
      Get.snackbar('Info', 'Tidak ada profil lansia yang dimuat');
      return;
    }

    _isLoading.value = true;

    final age = int.tryParse(umurController.text);

    final result = await _elderlyRepository.update(
      _elderlyId!,
      fullName: namaController.text.isNotEmpty ? namaController.text : null,
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
      Get.snackbar('Error', result['message'] ?? 'Gagal menyimpan perubahan');
      return;
    }

    final updatedData = result['data'] as Map<String, dynamic>?;
    final updatedName =
        updatedData?['full_name']?.toString() ?? namaController.text;
    final updatedAge = updatedData?['age']?.toString() ?? umurController.text;
    final updatedGender =
        updatedData?['gender']?.toString() ?? jenisKelaminController.text;
    final updatedImage = updatedData?['photo_url']?.toString();

    Get.find<PatientShellController>().updatePatientProfile(
      name: updatedName,
      age: updatedAge.isNotEmpty ? '$updatedAge Tahun' : '',
      gender: updatedGender,
      image: updatedImage?.isNotEmpty == true
          ? updatedImage
          : _patientImage.value,
    );

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadElderly();
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
  void onClose() {
    for (final worker in _shellWorkers) {
      worker.dispose();
    }
    namaController.dispose();
    umurController.dispose();
    jenisKelaminController.dispose();
    riwayatMedisController.dispose();
    minatHobiController.dispose();
    super.onClose();
  }
}
