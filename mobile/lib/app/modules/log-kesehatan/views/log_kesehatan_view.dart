import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/log_kesehatan_controller.dart';

class LogKesehatanView extends GetView<LogKesehatanController> {
  const LogKesehatanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      // 1. Memindahkan bagian Top Bar ke AppBar agar otomatis Sticky (tidak hilang saat discroll)
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        scrolledUnderElevation:
            0, // Mencegah perubahan warna saat discroll di Material 3
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1C1B1C)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Data Kesehatan',
          style: TextStyle(
            color: Color(0xFF1C1B1C),
            fontSize: 19,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- MAIN CONTENT ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul & Deskripsi
                      const Text(
                        'Data Kesehatan',
                        style: TextStyle(
                          color: Color(0xFF1C1B1C),
                          fontSize: 21,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Catat tanda-tanda vital dan kondisi keseluruhan hari ini.',
                        style: TextStyle(
                          color: Color(0xFF77767B),
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans',
                          height: 1.50,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // --- SEGMENTED BUTTONS (Kondisi Keseluruhan) ---
                      const Text(
                        'KONDISI KESELURUHAN',
                        style: TextStyle(
                          color: Color(0xFF47464B),
                          fontSize: 11,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatusChip(
                              'Normal',
                              Icons.sentiment_satisfied_alt,
                              false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatusChip(
                              'Perhatian',
                              Icons.sentiment_neutral,
                              true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatusChip(
                              'Kritis',
                              Icons.sentiment_very_dissatisfied,
                              false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // --- INFO PASIEN & TANGGAL ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E0E0).withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFBBF246),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selasa',
                                        style: TextStyle(
                                          color: Color(0xFF77767B),
                                          fontSize: 10,
                                          fontFamily: 'Plus Jakarta Sans',
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        '5 Mei 2026',
                                        style: TextStyle(
                                          color: Color(0xFF1C1B1C),
                                          fontSize: 12,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 28,
                              color: const Color(0xFFC8C5CB),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFBBF246),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pasien',
                                        style: TextStyle(
                                          color: Color(0xFF77767B),
                                          fontSize: 10,
                                          fontFamily: 'Plus Jakarta Sans',
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Ibu Siti',
                                        style: TextStyle(
                                          color: Color(0xFF1C1B1C),
                                          fontSize: 12,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- DAFTAR VITAL SIGNS (Dibuat menjadi Input Field) ---
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildVitalRow(
                              Icons.water_drop_outlined,
                              const Color(0xFFE88B63),
                              const Color(0xFFFFEBDD),
                              'Kolestrol',
                              '180',
                              'mg/dL',
                              TextInputType.number,
                            ),
                            _buildDivider(),
                            _buildVitalRow(
                              Icons.favorite_border,
                              const Color(0xFF6A9963),
                              const Color(0xFFE6F3E6),
                              'Tensi',
                              '120/80',
                              'mmHg',
                              TextInputType.text,
                            ), // Pake text supaya bisa ketik "/"
                            _buildDivider(),
                            _buildVitalRow(
                              Icons.science_outlined,
                              const Color(0xFF77767B),
                              const Color(0xFFF2F2F2),
                              'Asam Urat',
                              '5.5',
                              'mg/dL',
                              const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                            _buildDivider(),
                            _buildVitalRow(
                              Icons.bloodtype_outlined,
                              const Color(0xFFD35555),
                              const Color(0xFFFFE6E6),
                              'Gula Darah',
                              '98.6',
                              'mg/dL',
                              const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                            _buildDivider(),
                            _buildVitalRow(
                              Icons.device_thermostat_outlined,
                              const Color(0xFF77767B),
                              const Color(0xFFF2F2F2),
                              'Suhu',
                              '36.5',
                              '°C',
                              const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                            _buildDivider(),
                            _buildVitalRow(
                              Icons.monitor_heart_outlined,
                              const Color(0xFF6A9963),
                              const Color(0xFFE6F3E6),
                              'Detak Jantung',
                              '72',
                              'bpm',
                              TextInputType.number,
                            ),
                            _buildDivider(),
                            _buildVitalRow(
                              Icons.air_outlined,
                              const Color(0xFFE88B63),
                              const Color(0xFFFFEBDD),
                              'Saturasi',
                              '98.6',
                              '%',
                              const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                            _buildDivider(),
                            _buildVitalRow(
                              Icons.monitor_weight_outlined,
                              const Color(0xFF77767B),
                              const Color(0xFFF2F2F2),
                              'Berat Badan',
                              '70',
                              'Kg',
                              TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- TEXTBOX CATATAN ---
                      const Text(
                        'Catatan',
                        style: TextStyle(
                          color: Color(0xFF1C1B1C),
                          fontSize: 13,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              'Ada catatan atau keluhan tambahan hari\nini?',
                          hintStyle: const TextStyle(
                            color: Color(0xFFC8C5CB),
                            fontSize: 14,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFD4D4D8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFBBF246),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- TOMBOL SIMPAN ---
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            // Tindakan simpan
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF192126),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Simpan Data Kesehatan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- REUSABLE WIDGETS ---

  Widget _buildStatusChip(String title, IconData icon, bool isActive) {
    final bgColor = isActive
        ? const Color(0xFFBBF246)
        : const Color(0xFF192126);
    final iconColor = isActive ? Colors.black : const Color(0xFFBBF246);
    final textColor = isActive ? Colors.black : const Color(0xFF77767B);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Fungsi diupdate untuk memuat TextField interaktif
  Widget _buildVitalRow(
    IconData icon,
    Color iconColor,
    Color iconBgColor,
    String title,
    String hintValue,
    String unit,
    TextInputType keyboardType,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ), // Padding dikecilkan sedikit untuk kompensasi textfield
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1C1B1C),
                  fontSize: 13,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 70, // Batas lebar agar inputan tidak terlalu panjang
                child: TextField(
                  textAlign: TextAlign.right,
                  keyboardType: keyboardType, // Keyboard menyesuaikan isian
                  style: const TextStyle(
                    color: Color(
                      0xFF1C1B1C,
                    ), // Warna teks waktu ngetik jadi gelap
                    fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        hintValue, // Placeholder seperti "180" atau "120/80"
                    hintStyle: const TextStyle(
                      color: Color(0xFFD4D4D8), // Warna abu-abu saat kosong
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder
                        .none, // Menghilangkan garis pinggir biar bersih
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 40, // Diberi min-width biar baris satuannya lurus rata
                child: Text(
                  unit,
                  style: const TextStyle(
                    color: Color(0xFF1C1B1C),
                    fontSize: 10,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF4F4F5));
  }
}
