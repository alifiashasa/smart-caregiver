import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F8),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.toNamed(Routes.TAMBAH_LANSIA);
          if (result == true) {
            controller.loadElderly();
            controller.loadUnreadCount();
          }
        },
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
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.PROFIL_CAREGIVER),
                    child: Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFE5E2E1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/caregiver_profile.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Get.toNamed(Routes.NOTIFIKASI);
                      controller.loadUnreadCount();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const ShapeDecoration(shape: CircleBorder()),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Positioned.fill(
                            child: Icon(
                              Icons.notifications_none,
                              color: Color(0xFF18181B),
                            ),
                          ),
                          Obx(() {
                            final count = controller.unreadCount;
                            if (count <= 0) return const SizedBox.shrink();
                            return Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const ShapeDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: CircleBorder(),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  count > 99 ? '99+' : count.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF192126)),
                  );
                }

                return SingleChildScrollView(
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

                      // Dashboard Cards (stats from API)
                      Row(
                        children: [
                          _buildStatCard(
                            icon: Icons.people_outline,
                            iconColor: const Color(0xFF1B1B1E),
                            iconBgColor: const Color(0x191B1B1E),
                            value: '${controller.elderlyList.length}',
                            label: 'Total Pasien',
                            cardColor: Colors.white,
                            borderColor: null,
                          ),
                          const SizedBox(width: 16),
                          _buildStatCard(
                            icon: Icons.warning_amber_rounded,
                            iconColor: const Color(0xFFD97706),
                            iconBgColor: const Color(0xFFFEF3C7),
                            value: '${controller.needsAttentionCount}',
                            label: 'Perlu Perhatian',
                            cardColor: Colors.white,
                            borderColor: const Color(0xFFFEF3C7),
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
                          Text(
                            'Pasien Anda',
                            style: const TextStyle(
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

                      // Patient List from API
                      if (controller.elderlyList.isEmpty)
                        _buildEmptyPatientState()
                      else
                        ...controller.elderlyList.asMap().entries.map((entry) {
                          final e = entry.value;
                          return _buildPatientCard(
                            name: e.fullName,
                            age: e.ageLabel,
                            status: HomeController.statusLabel(
                              e.latestHealthStatus,
                            ),
                            isCritical: e.needsAttention,
                            isLoading: false,
                            onTap: () => controller.navigateToDashboard(e),
                          );
                        }),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
    required Color cardColor,
    Color? borderColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: cardColor,
          shape: RoundedRectangleBorder(
            side: borderColor != null
                ? BorderSide(width: 1, color: borderColor)
                : BorderSide.none,
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
              decoration: ShapeDecoration(
                color: iconBgColor,
                shape: const CircleBorder(),
              ),
              child: Icon(icon, color: iconColor),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1C1B1C),
                fontSize: 30,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.27,
                letterSpacing: -0.60,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
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
    );
  }

  Widget _buildEmptyPatientState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(Icons.people_outline, size: 48, color: Color(0xFFA3A1A6)),
          SizedBox(height: 16),
          Text(
            'Belum ada pasien',
            style: TextStyle(
              color: Color(0xFF77767B),
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tambahkan pasien pertama Anda',
            style: TextStyle(
              color: Color(0xFFA3A1A6),
              fontSize: 14,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard({
    required String name,
    required String age,
    required String status,
    required bool isCritical,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 20,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Image
            Container(
              width: 44,
              height: 44,
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(shape: CircleBorder()),
              child: CachedNetworkImage(
                imageUrl:
                    "https://ui-avatars.com/api/?name=$name&background=${isCritical ? 'f59e0b' : 'BBF246'}&color=${isCritical ? 'fff' : '192126'}",
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, color: Color(0xFF71717A)),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xFF18181B),
                      fontSize: 22,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    age,
                    style: const TextStyle(
                      color: Color(0xFF71717A),
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: ShapeDecoration(
                color: isCritical
                    ? const Color(0xFFE4E4E7)
                    : const Color(0xFFBBF246),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isCritical
                      ? const Color(0xFF18181B)
                      : const Color(0xFF576755),
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
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
