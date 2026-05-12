import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifikasi_controller.dart';

class NotifikasiView extends GetView<NotifikasiController> {
  const NotifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
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
          'Notifikasi',
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
                    image: AssetImage('assets/images/patient_ibu_siti.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Cards
              _buildNotificationCard(
                name: 'Kritis - Oma Maria',
                time: 'Baru saja',
                description:
                    'Gula darah terdeteksi sangat rendah (65 mg/dL). Segera berikan penanganan!',
                hasDot: true,
                isCritical: true,
              ),
              const SizedBox(height: 16),
              _buildNotificationCard(
                name: 'Semua Lansia',
                time: '08.30',
                description: 'Terapi Fisik: Peregangan ringan',
                hasDot: true,
              ),
              const SizedBox(height: 16),
              _buildNotificationCard(
                name: 'Ibu Siti',
                time: '07.00',
                description:
                    'Obat pagi: Aspirin & Vitamin, diminum sesudah makan.',
                hasDot: true,
              ),
              const SizedBox(height: 16),
              _buildNotificationCard(
                name: 'Opa Joko',
                time: '07.00',
                description:
                    'Obat pagi: Aspirin & Vitamin, diminum sesudah makan.',
                hasDot: true,
              ),
              const SizedBox(height: 16),
              _buildNotificationCard(
                name: 'Oma Maria',
                time: 'Kemarin',
                description:
                    'Obat pagi: Aspirin & Vitamin, diminum sesudah makan.',
                hasDot: false,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String name,
    required String time,
    required String description,
    required bool hasDot,
    bool isCritical = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF384046),
        borderRadius: BorderRadius.circular(15),
        border: isCritical
            ? Border.all(color: const Color(0xFFEF4444), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: isCritical ? const Color(0xFFEF4444) : Colors.white,
                  fontSize: 16,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                  height: 1.38,
                ),
              ),
              Row(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      color: Color(0xFF737373),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (hasDot) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isCritical
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFBBF246),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.50),
              fontSize: 13,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
