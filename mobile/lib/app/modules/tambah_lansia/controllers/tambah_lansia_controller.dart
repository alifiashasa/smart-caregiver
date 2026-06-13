import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/elderly_repository.dart';

class TambahLansiaController extends GetxController {
  final ElderlyRepository _elderlyRepository;

  TambahLansiaController({required ElderlyRepository elderlyRepository})
    : _elderlyRepository = elderlyRepository;

  // ── Reactive state ──
  final _namaLengkap = ''.obs;
  final _usia = ''.obs;
  final _fotoProfilPath = ''.obs;
  final _fotoProfilBytes = Rx<Uint8List?>(null);

  /// Public RxString for [_buildRadioBtn] compatibility
  final jenisKelamin = 'Laki-laki'.obs;
  final _riwayatMedis = ''.obs;

  /// Public RxString for [_buildRadioBtn] compatibility
  final kondisiFisik = 'Mandiri'.obs;

  /// Public RxString for [_buildRadioBtn] compatibility
  final mobilitas = 'Bisa Berjalan'.obs;

  final _minatHobi = ''.obs;
  final _isLoading = false.obs;

  // ── Public getters ──
  String get namaLengkap => _namaLengkap.value;
  String get usia => _usia.value;
  String get fotoProfilPath => _fotoProfilPath.value;
  Uint8List? get fotoProfilBytes => _fotoProfilBytes.value;
  String get riwayatMedis => _riwayatMedis.value;
  String get minatHobi => _minatHobi.value;
  bool get isLoading => _isLoading.value;

  set namaLengkap(String value) => _namaLengkap.value = value;
  set usia(String value) => _usia.value = value;
  set riwayatMedis(String value) => _riwayatMedis.value = value;
  set minatHobi(String value) => _minatHobi.value = value;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _fotoProfilPath.value = image.path;
        _fotoProfilBytes.value = await image.readAsBytes();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  Future<void> simpan() async {
    if (_isLoading.value) return;

    if (_namaLengkap.value.isEmpty || _usia.value.isEmpty) {
      Get.snackbar('Error', 'Nama dan Usia harus diisi');
      return;
    }

    final usiaInt = int.tryParse(_usia.value);
    if (usiaInt == null) {
      Get.snackbar('Error', 'Usia harus berupa angka');
      return;
    }

    _isLoading.value = true;

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

    final result = await _elderlyRepository.create(
      fullName: _namaLengkap.value,
      age: usiaInt,
      gender: gender,
      photoUrl: _fotoProfilPath.value.isNotEmpty ? _fotoProfilPath.value : null,
      medicalHistory: _riwayatMedis.value.isNotEmpty
          ? _riwayatMedis.value
          : null,
      physicalCondition: kondisiFisik.value.isNotEmpty
          ? kondisiFisik.value
          : null,
      mobilityLevel: mobilityLevel,
      hobbiesInterests: _minatHobi.value.isNotEmpty ? _minatHobi.value : null,
    );

    _isLoading.value = false;

    if (result['error'] == true) {
      Get.snackbar('Error', result['message'] ?? 'Gagal menyimpan data');
      return;
    }

    Get.back(result: true);
    Get.snackbar('Sukses', 'Data Lansia berhasil ditambahkan');
  }
}
