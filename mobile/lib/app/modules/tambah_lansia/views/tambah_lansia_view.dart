import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tambah_lansia_controller.dart';

class TambahLansiaView extends GetView<TambahLansiaController> {
  const TambahLansiaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F8),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.80),
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F4), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Tambah Lansia Baru',
          style: TextStyle(
            color: Color(0xFF1C1917),
            fontSize: 19,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.40,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF5F5F4), width: 1),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/caregiver_profile.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Informasi Dasar
            _buildCard(
              title: 'Informasi Dasar',
              children: [
                Center(
                  child: GestureDetector(
                    onTap: controller.pickImage,
                    child: Column(
                      children: [
                        Obx(
                          () => Container(
                            width: 88,
                            height: 88,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F3F2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFC8C5CB),
                                width: 1,
                              ),
                            ),
                            child: controller.fotoProfilPath.value.isEmpty
                                ? const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Color(0xFF858387),
                                    size: 32,
                                  )
                                : Image.file(
                                    File(controller.fotoProfilPath.value),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Unggah Foto Profil',
                          style: TextStyle(
                            color: Color(0xFF47464B),
                            fontSize: 14,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _buildFieldLabel('Nama Lengkap'),
                const SizedBox(height: 4),
                _buildTextField(
                  hint: 'Masukkan nama lengkap',
                  onChanged: (val) => controller.namaLengkap.value = val,
                ),
                const SizedBox(height: 12),

                _buildFieldLabel('Usia (Tahun)'),
                const SizedBox(height: 4),
                _buildTextField(
                  hint: 'Contoh: 75',
                  keyboardType: TextInputType.number,
                  onChanged: (val) => controller.usia.value = val,
                ),
                const SizedBox(height: 12),

                _buildFieldLabel('Jenis Kelamin'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: _buildRadioBtn(
                        title: 'Laki-laki',
                        groupValue: controller.jenisKelamin,
                        activeColor: const Color(0xFF192126),
                        activeTextColor: Colors.white,
                        centerText: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildRadioBtn(
                        title: 'Perempuan',
                        groupValue: controller.jenisKelamin,
                        activeColor: const Color(0xFF192126),
                        activeTextColor: Colors.white,
                        centerText: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 2. Latar Belakang Kesehatan
            _buildCard(
              title: 'Latar Belakang Kesehatan',
              children: [
                _buildFieldLabel('Riwayat Medis'),
                const SizedBox(height: 4),
                _buildTextField(
                  hint: 'contoh: hipertensi, diabetes',
                  maxLines: 3,
                  onChanged: (val) => controller.riwayatMedis.value = val,
                ),
                const SizedBox(height: 12),

                _buildFieldLabel('Kondisi Fisik'),
                const SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildRadioBtn(
                      title: 'Mandiri',
                      groupValue: controller.kondisiFisik,
                      activeColor: const Color(0xFFBBF246),
                      activeTextColor: Colors.black,
                      centerText: true,
                    ),
                    const SizedBox(height: 4),
                    _buildRadioBtn(
                      title: 'Butuh Bantuan Sebagian',
                      groupValue: controller.kondisiFisik,
                      activeColor: const Color(0xFFBBF246),
                      activeTextColor: Colors.black,
                      centerText: true,
                    ),
                    const SizedBox(height: 4),
                    _buildRadioBtn(
                      title: 'Butuh Bantuan Penuh',
                      groupValue: controller.kondisiFisik,
                      activeColor: const Color(0xFFBBF246),
                      activeTextColor: Colors.black,
                      centerText: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _buildFieldLabel('Tingkat Mobilitas'),
                const SizedBox(height: 4),
                Wrap(
                  runSpacing: 8,
                  children: [
                    _buildRadioBtn(
                      title: 'Bisa Berjalan',
                      groupValue: controller.mobilitas,
                      activeColor: const Color(0xFFBBF246),
                      activeTextColor: Colors.black,
                      verticalPadding: 4,
                    ),
                    _buildRadioBtn(
                      title: 'Alat Bantu',
                      groupValue: controller.mobilitas,
                      activeColor: const Color(0xFFBBF246),
                      activeTextColor: Colors.black,
                      verticalPadding: 4,
                    ),
                    _buildRadioBtn(
                      title: 'Kursi Roda',
                      groupValue: controller.mobilitas,
                      activeColor: const Color(0xFFBBF246),
                      activeTextColor: Colors.black,
                      verticalPadding: 4,
                    ),
                    _buildRadioBtn(
                      title: 'Berbaring',
                      groupValue: controller.mobilitas,
                      activeColor: const Color(0xFFBBF246),
                      activeTextColor: Colors.black,
                      verticalPadding: 4,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 3. Personal & Minat
            _buildCard(
              title: 'Personal & Minat',
              children: [
                _buildFieldLabel('Minat dan Hobi'),
                const SizedBox(height: 4),
                _buildTextField(
                  hint: 'contoh: musik, berkebun, membaca',
                  maxLines: 3,
                  onChanged: (val) => controller.minatHobi.value = val,
                ),
                const SizedBox(height: 8),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Color(0xFF858387),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Digunakan untuk rekomendasi aktivitas AI.',
                        style: TextStyle(
                          color: Color(0xFF858387),
                          fontSize: 12,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Footer Actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: controller.simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF192126),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Simpan Data',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: Color(0xFF47464B),
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF47464B),
        fontSize: 14,
        fontFamily: 'Plus Jakarta Sans',
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.14,
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1418181B),
            blurRadius: 16,
            offset: Offset(0, 4),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1C1B1C),
              fontSize: 20,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
              height: 1.40,
            ),
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 16,
        color: Color(0xFF1B1B1B),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 16,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0xFFF7F3F2),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFC8C5CB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFC8C5CB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF858387)),
        ),
      ),
    );
  }

  Widget _buildRadioBtn({
    required String title,
    required RxString groupValue,
    required Color activeColor,
    required Color activeTextColor,
    double verticalPadding = 8.0,
    bool centerText = false,
  }) {
    return Obx(() {
      final isSelected = groupValue.value == title;
      return GestureDetector(
        onTap: () => groupValue.value = title,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: isSelected ? activeColor : const Color(0xFFC8C5CB),
            ),
          ),
          width: centerText ? double.infinity : null,
          alignment: centerText ? Alignment.center : null,
          child: Text(
            title,
            textAlign: centerText ? TextAlign.center : null,
            style: TextStyle(
              color: isSelected ? activeTextColor : const Color(0xFF47464B),
              fontSize: 14,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              height: 1.43,
              letterSpacing: 0.14,
            ),
          ),
        ),
      );
    });
  }
}
