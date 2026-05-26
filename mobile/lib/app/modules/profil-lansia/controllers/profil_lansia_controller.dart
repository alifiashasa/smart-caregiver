import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/elderly_api.dart';
import '../../../routes/app_pages.dart';

class ProfilLansiaController extends GetxController {
  final currentIndex = 3.obs;
  final patientImage = 'assets/images/patient_ibu_siti.png'.obs;
  final isLoading = false.obs;

  int? elderlyId;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController umurController = TextEditingController();
  final TextEditingController jenisKelaminController = TextEditingController();
  final TextEditingController riwayatMedisController = TextEditingController();
  final TextEditingController minatHobiController = TextEditingController();

  final ElderlyApi _api = ElderlyApi();

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      elderlyId = args['elderly_id'] as int?;

      if (args['from'] != null) {
        currentIndex.value = args['from'];
      }

      namaController.text = args['name'] ?? 'Ibu Siti';
      umurController.text = (args['age'] ?? '55 Tahun').replaceAll(
        ' Tahun',
        '',
      );
      jenisKelaminController.text = args['gender'] ?? 'Perempuan';
      patientImage.value =
          args['image'] ?? 'assets/images/patient_ibu_siti.png';
    } else {
      namaController.text = 'Ibu Siti';
      umurController.text = '55';
      jenisKelaminController.text = 'Perempuan';
    }

    if (elderlyId != null) {
      loadProfile(elderlyId!);
    }
  }

  Future<void> loadProfile(int id) async {
    isLoading.value = true;

    final result = await _api.getById(id);

    isLoading.value = false;

    if (result['error'] == true) return;

    final data = result['data'] as Map<String, dynamic>?;
    if (data != null) {
      namaController.text = data['full_name'] ?? namaController.text;
      umurController.text = data['age']?.toString() ?? umurController.text;
      jenisKelaminController.text = data['gender'] ?? jenisKelaminController.text;
      riwayatMedisController.text = data['medical_history'] ?? '';
      minatHobiController.text = data['hobbies_interests'] ?? '';
      if (data['photo_url'] != null && data['photo_url'].toString().isNotEmpty) {
        patientImage.value = data['photo_url'];
      }
    }
  }

  void changePage(int index) {
    if (currentIndex.value == index) return;

    int previousIndex = currentIndex.value;
    currentIndex.value = index;

    final args = {
      'from': previousIndex,
      'name': namaController.text,
      'age': umurController.text,
      'image': patientImage.value,
      'gender': jenisKelaminController.text,
      if (elderlyId != null) 'elderly_id': elderlyId,
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
    if (elderlyId == null) {
      Get.snackbar('Info', 'Tidak ada profil lansia yang dimuat');
      return;
    }

    isLoading.value = true;

    final age = int.tryParse(umurController.text);

    final result = await _api.update(
      elderlyId!,
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

    isLoading.value = false;

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
    if (currentIndex.value != 3) {
      Future.delayed(const Duration(milliseconds: 10), () {
        currentIndex.value = 3;
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
