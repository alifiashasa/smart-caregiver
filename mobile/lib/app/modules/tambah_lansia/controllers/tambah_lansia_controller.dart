import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TambahLansiaController extends GetxController {
  final namaLengkap = ''.obs;
  final usia = ''.obs;
  final fotoProfilPath = ''.obs;

  final jenisKelamin = 'Laki-laki'.obs; // Laki-laki or Perempuan

  final riwayatMedis = ''.obs;

  final kondisiFisik =
      'Mandiri'.obs; // Mandiri, Butuh Bantuan Sebagian, Butuh Bantuan Penuh
  final mobilitas =
      'Bisa Berjalan'.obs; // Bisa Berjalan, Alat Bantu, Kursi Roda, Berbaring

  final minatHobi = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        fotoProfilPath.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  void simpan() {
    if (namaLengkap.value.isEmpty || usia.value.isEmpty) {
      Get.snackbar('Error', 'Nama dan Usia harus diisi');
      return;
    }
    // Save logic implementation here
    Get.back();
    Get.snackbar('Sukses', 'Data Lansia berhasil ditambahkan');
  }
}
