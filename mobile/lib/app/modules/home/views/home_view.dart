import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F8),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.TAMBAH_LANSIA),
        backgroundColor: const Color(0xFF18181B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Top App Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 16,
                left: 20,
                right: 20,
                bottom: 16,
              ),
              decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE5E2E1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        child: Image.network(
                          "https://placehold.co/40x40",
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'CareTrack',
                        style: TextStyle(
                          color: Color(0xFF18181B),
                          fontSize: 19,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                          height: 1.27,
                          letterSpacing: -0.75,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const ShapeDecoration(shape: CircleBorder()),
                    child: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFF18181B),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 20,
                  right: 20,
                  bottom: 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Section
                    const Text(
                      'Selamat Pagi, Sari',
                      style: TextStyle(
                        color: Color(0xFF1C1B1C),
                        fontSize: 21,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        height: 1.27,
                        letterSpacing: -0.60,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Berikut adalah status pasien Anda hari ini.',
                      style: TextStyle(
                        color: Color(0xFF47464B),
                        fontSize: 18,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.56,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dashboard Cards
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x26A1A1AA),
                                  blurRadius: 16,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: const ShapeDecoration(
                                    color: Color(0x191B1B1E),
                                    shape: CircleBorder(),
                                  ),
                                  child: const Icon(
                                    Icons.people_outline,
                                    color: Color(0xFF1B1B1E),
                                  ),
                                ),
                                const Text(
                                  '8',
                                  style: TextStyle(
                                    color: Color(0xFF1C1B1C),
                                    fontSize: 30,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w700,
                                    height: 1.27,
                                    letterSpacing: -0.60,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Total Pasien',
                                  style: TextStyle(
                                    color: Color(0xFF47464B),
                                    fontSize: 14,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFFEF3C7),
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x26A1A1AA),
                                  blurRadius: 16,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: const ShapeDecoration(
                                    color: Color(0xFFFEF3C7),
                                    shape: CircleBorder(),
                                  ),
                                  child: const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                                const Text(
                                  '2',
                                  style: TextStyle(
                                    color: Color(0xFF1C1B1C),
                                    fontSize: 30,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w700,
                                    height: 1.27,
                                    letterSpacing: -0.60,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Perlu Perhatian',
                                  style: TextStyle(
                                    color: Color(0xFF47464B),
                                    fontSize: 14,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Search Bar Placeholder
                    Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
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
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Color(0xFF8C9093),
                            size: 20,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Cari Pasien',
                            style: TextStyle(
                              color: Color(0xFF8C9093),
                              fontSize: 16,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Patient List Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pasien Anda',
                          style: TextStyle(
                            color: Color(0xFF1C1B1C),
                            fontSize: 24,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                            letterSpacing: -0.24,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x19A1A1AA),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.filter_list,
                                size: 16,
                                color: Color(0xFF1C1B1C),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Filter',
                                style: TextStyle(
                                  color: Color(0xFF1C1B1C),
                                  fontSize: 14,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w500,
                                  height: 1.43,
                                  letterSpacing: 0.14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Patient List
                    _buildPatientCard(
                      name: 'Ibu Siti',
                      age: '55 Tahun',
                      status: 'Stabil',
                      isCritical: false,
                    ),
                    const SizedBox(height: 16),
                    _buildPatientCard(
                      name: 'Pak Budi',
                      age: '67 Tahun',
                      status: 'Perlu Perhatian',
                      isCritical: true,
                    ),
                    const SizedBox(height: 16),
                    _buildPatientCard(
                      name: 'Oma Maria',
                      age: '88 Tahun',
                      status: 'High BP',
                      isCritical: true,
                    ),
                    const SizedBox(height: 16),
                    _buildPatientCard(
                      name: 'Opa Joko',
                      age: '56 Tahun',
                      status: 'Stabil',
                      isCritical: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard({
    required String name,
    required String age,
    required String status,
    required bool isCritical,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.DASHBOARD),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x26A1A1AA),
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFE5E2E1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: Image.network(
                "https://placehold.co/60x60",
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xFF1C1B1C),
                      fontSize: 20,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                      height: 1.40,
                    ),
                  ),
                  Text(
                    age,
                    style: const TextStyle(
                      color: Color(0xFF47464B),
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: ShapeDecoration(
                color: isCritical
                    ? const Color(0xFF192126)
                    : const Color(0xFFBBF246),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isCritical ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
