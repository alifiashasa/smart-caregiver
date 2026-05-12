import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/jadwal_lansia_controller.dart';

class JadwalLansiaView extends GetView<JadwalLansiaController> {
  const JadwalLansiaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
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
          'Jadwal Oleh Caregiver',
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 884),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 48),
            decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 672),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 32,
                        left: 20,
                        right: 20,
                        bottom: 66,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama Aktivitas',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 56,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16.50,
                            ),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFC8C5CB),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x0C000000),
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Contoh: Jalan Pagi, Minum Obat',
                              style: TextStyle(
                                color: Color(0xFF77767B),
                                fontSize: 16,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Tipe',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              runSpacing: 8,
                              children: [
                                _buildTypeChip(
                                  'Medis',
                                  Icons.medical_services,
                                  true,
                                ),
                                _buildTypeChip(
                                  'Pemeriksaan',
                                  Icons.assignment,
                                  false,
                                ),
                                _buildTypeChip(
                                  'Aktivitas',
                                  Icons.directions_run,
                                  false,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Tanggal',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildInputField('mm/dd/yyyy', Icons.calendar_today),
                          const SizedBox(height: 24),
                          const Text(
                            'Waktu',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildInputField('09:00 AM', Icons.access_time),
                          const SizedBox(height: 24),
                          const Text(
                            'Mengulang',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildInputField('Sekali', Icons.keyboard_arrow_down),
                          const SizedBox(height: 32),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0x4CC8C5CB),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x0A18181B),
                                  blurRadius: 16,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const ShapeDecoration(
                                          color: Color(0xFFF1FFD4),
                                          shape: CircleBorder(),
                                        ),
                                        child: const Icon(
                                          Icons.notifications_active,
                                          color: Color(0xFF576755),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pemberitahuan Alarm',
                                              style: TextStyle(
                                                color: Color(0xFF1C1B1C),
                                                fontSize: 14,
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Dapatkan pemberitahuan \n15 menit sebelumnya',
                                              style: TextStyle(
                                                color: Color(0xFF47464B),
                                                fontSize: 12,
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Switch
                                Container(
                                  width: 44,
                                  height: 24,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFBBF246),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.only(right: 2),
                                      decoration: const ShapeDecoration(
                                        color: Colors.white,
                                        shape: CircleBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),
                          GestureDetector(
                            onTap: () {
                              // Save schedule action
                            },
                            child: Container(
                              width: double.infinity,
                              height: 48,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF192126),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x0F000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'Simpan Jadwal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: isSelected ? const Color(0xFF192126) : const Color(0xFFFDF8F8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isSelected
                ? const Color(0xFF192126)
                : const Color(0xFFC8C5CB),
          ),
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : const Color(0xFF47464B),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF47464B),
              fontSize: 14,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String hint, IconData icon) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFC8C5CB)),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: const TextStyle(
              color: Color(0xFF1C1B1C),
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          Icon(icon, size: 20, color: const Color(0xFF47464B)),
        ],
      ),
    );
  }
}
