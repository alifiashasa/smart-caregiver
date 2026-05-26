import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profil_caregiver_controller.dart';

class ProfilCaregiverView extends GetView<ProfilCaregiverController> {
  const ProfilCaregiverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 884),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 174),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildHeader(), _buildContent()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const ShapeDecoration(
        color: Color(0xE5FAFAFA),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFF4F4F5)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFF18181B)),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Profile Caregiver',
            style: TextStyle(
              color: Color(0xFF18181B),
              fontSize: 20,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
              height: 1.60,
              letterSpacing: -0.60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture and Info
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 4,
                          color: Color(0xFFFDF8F8),
                        ),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0xCCE5E2E1),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/caregiver_profile.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: ShapeDecoration(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: -2,
                        ),
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => Text(
                  controller.fullName.value.isNotEmpty
                      ? controller.fullName.value
                      : 'Sri Setyani',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF1C1B1C),
                    fontSize: 24,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  controller.email.value.isNotEmpty
                      ? controller.email.value
                      : 'Srisetyani77@gmail.com',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF47464B),
                    fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Menu Options
          Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x66E5E2E1),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.edit_outlined,
                  text: 'Edit Profile',
                  onTap: () {},
                ),

              ],
            ),
          ),
          const SizedBox(height: 32),

          // Logout Button
          GestureDetector(
            onTap: controller.logout,
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
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white,
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
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF18181B), size: 24),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: const TextStyle(
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
            const Icon(Icons.chevron_right, color: Color(0xFF18181B), size: 24),
          ],
        ),
      ),
    );
  }
}
