import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/template_jadwal_controller.dart';

class TemplateJadwalView extends GetView<TemplateJadwalController> {
  const TemplateJadwalView({super.key});

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
          'Pilih dari Template',
          style: TextStyle(
            color: Color(0xFF1C1917),
            fontSize: 19,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.40,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Template Jadwal Rutin',
                      style: TextStyle(
                        color: Color(0xFF1C1B1C),
                        fontSize: 21,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pilih kegiatan rutin mana saja yang ingin Anda tambahkan untuk hari ini.',
                      style: TextStyle(
                        color: Color(0xFF77767B),
                        fontSize: 14,
                        fontFamily: 'Plus Jakarta Sans',
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => Column(
                        children: controller.templates.map((template) {
                          return _buildTemplateCard(template);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Button
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFF5F5F4), width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.saveTemplateSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF192126),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Tambahkan ke Jadwal',
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
    );
  }

  Widget _buildTemplateCard(TemplateJadwal template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF77767B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      template.time,
                      style: const TextStyle(
                        color: Color(0xFF77767B),
                        fontSize: 12,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  template.title,
                  style: const TextStyle(
                    color: Color(0xFF1C1B1C),
                    fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  template.description,
                  style: const TextStyle(
                    color: Color(0xFF77767B),
                    fontSize: 13,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Obx(
            () => Switch(
              value: template.isEnabled.value,
              onChanged: (val) => template.isEnabled.value = val,
              activeThumbColor: const Color(0xFF192126),
              activeTrackColor: const Color(0xFFBBF246),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFE5E5E5),
            ),
          ),
        ],
      ),
    );
  }
}
