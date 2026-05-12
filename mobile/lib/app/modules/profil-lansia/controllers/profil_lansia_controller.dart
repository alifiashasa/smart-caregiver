import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ProfilLansiaController extends GetxController {
  final currentIndex = 3.obs;
  final patientImage = 'assets/images/patient_ibu_siti.png'.obs;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController umurController = TextEditingController();
  final TextEditingController jenisKelaminController = TextEditingController();
  final TextEditingController riwayatMedisController = TextEditingController(
    text: 'Hipertensi ringan',
  );
  final TextEditingController minatHobiController = TextEditingController(
    text: 'Berkebun dan Membaca',
  );

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

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      if (Get.arguments['from'] != null) {
        currentIndex.value = Get.arguments['from'];
      }
      namaController.text = Get.arguments['name'] ?? 'Ibu Siti';
      umurController.text = (Get.arguments['age'] ?? '55 Tahun').replaceAll(
        ' Tahun',
        '',
      );
      jenisKelaminController.text = Get.arguments['gender'] ?? 'Perempuan';
      patientImage.value =
          Get.arguments['image'] ?? 'assets/images/patient_ibu_siti.png';
    } else {
      namaController.text = 'Ibu Siti';
      umurController.text = '55';
      jenisKelaminController.text = 'Perempuan';
    }
  }

  void saveChanges() {
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

  void increment() => count.value++;
}
