import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/elderly_api.dart';

class TambahLansiaController extends GetxController {
  final namaLengkap = ''.obs;
  final usia = ''.obs;
  final fotoProfilPath = ''.obs;
  final fotoProfilBytes = Rx<Uint8List?>(null);

  final jenisKelamin = 'Laki-laki'.obs; // Laki-laki or Perempuan

  final riwayatMedis = ''.obs;

  final kondisiFisik =
      'Mandiri'.obs; // Mandiri, Butuh Bantuan Sebagian, Butuh Bantuan Penuh
  final mobilitas =
      'Bisa Berjalan'.obs; // Bisa Berjalan, Alat Bantu, Kursi Roda, Berbaring

  final minatHobi = ''.obs;

  final isLoading = false.obs;

  final ElderlyApi _api = ElderlyApi();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        fotoProfilPath.value = image.path;
        fotoProfilBytes.value = await image.readAsBytes();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  Future<void> simpan() async {
    if (namaLengkap.value.isEmpty || usia.value.isEmpty) {
      Get.snackbar('Error', 'Nama dan Usia harus diisi');
      return;
    }

    final usiaInt = int.tryParse(usia.value);
    if (usiaInt == null) {
      Get.snackbar('Error', 'Usia harus berupa angka');
      return;
    }

    isLoading.value = true;

    final gender = jenisKelamin.value == 'Laki-laki' ? 'male' : 'female';

    String? mobilityLevel;
    switch (mobilitas.value) {
      case 'Bisa Berjalan':
        mobilityLevel = 'independent';
        break;
      case 'Alat Bantu':
        mobilityLevel = 'assisted';
        break;
      case 'Kursi Roda':
        mobilityLevel = 'wheelchair';
        break;
      case 'Berbaring':
        mobilityLevel = 'bedridden';
        break;
    }

    final result = await _api.create(
      fullName: namaLengkap.value,
      age: usiaInt,
      gender: gender,
      photoUrl: fotoProfilPath.value.isNotEmpty ? fotoProfilPath.value : null,
      medicalHistory: riwayatMedis.value.isNotEmpty ? riwayatMedis.value : null,
      physicalCondition: kondisiFisik.value.isNotEmpty ? kondisiFisik.value : null,
      mobilityLevel: mobilityLevel,
      hobbiesInterests: minatHobi.value.isNotEmpty ? minatHobi.value : null,
    );

    isLoading.value = false;

    if (result['error'] == true) {
      Get.snackbar('Error', result['message'] ?? 'Gagal menyimpan data');
      return;
    }

    Get.back();
    Get.snackbar('Sukses', 'Data Lansia berhasil ditambahkan');
  }
}
