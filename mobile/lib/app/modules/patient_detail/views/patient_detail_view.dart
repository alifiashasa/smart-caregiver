import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/patient_detail_controller.dart';

class PatientDetailView extends GetView<PatientDetailController> {
  const PatientDetailView({super.key});

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
          'Riwayat Kesehatan',
          style: TextStyle(
            color: Color(0xFF1C1917),
            fontSize: 19,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.40,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingRecords) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF192126)),
          );
        }

        return SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: 48,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Texts
              const Text(
                'Riwayat Kesehatan',
                style: TextStyle(
                  color: Color(0xFF1C1B1C),
                  fontSize: 24,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                  letterSpacing: -0.24,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Riwayat kesehatan dan pemantauan tanda vital',
                style: TextStyle(
                  color: Color(0xFF47464B),
                  fontSize: 16,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              const SizedBox(height: 24),

              // Timeline items
              Obx(() {
                return Column(
                  children: controller.records.map((record) {
                    // Menggunakan widget TimelineCard yang baru dibuat
                    return TimelineCard(record: record);
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      );
      }),
    );
  }
}

// Memisahkan Card menjadi StatefulWidget agar memiliki state expand/collapse secara independen
class TimelineCard extends StatefulWidget {
  final Map<String, dynamic> record;

  const TimelineCard({super.key, required this.record});

  @override
  State<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<TimelineCard> {
  // State untuk melacak apakah kartu sedang dibuka atau ditutup
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final record = widget.record;
    bool hasSymptoms =
        record['symptoms'] != null && (record['symptoms'] as List).isNotEmpty;
    bool hasNotes =
        record['notes'] != null && record['notes'].toString().isNotEmpty;
    bool isCritical = record['status'] == 'Perlu Perhatian';

    // Opsional: Cek apakah ada detail tambahan untuk ditampilkan,
    // jika tidak ada, Anda mungkin ingin menyembunyikan icon dropdown sama sekali.
    bool hasDetails = hasSymptoms || hasNotes || isCritical;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadows: const [
          BoxShadow(
            color: Color(0x0A18181B),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 4,
              color: isCritical
                  ? const Color(0xFF192126)
                  : const Color(0xFFC6C5CF),
            ),
          ),
        ),
        padding: const EdgeInsets.only(left: 16), // Spaced from the line
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date & Status row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record['date'],
                  style: const TextStyle(
                    color: Color(0xFF47464B),
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                    letterSpacing: 0.14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: ShapeDecoration(
                    color: Color(record['color'] as int),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (isCritical)
                        const Icon(
                          Icons.info,
                          color: Color(0xFF192126),
                          size: 16,
                        ),
                      if (!isCritical)
                        const Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF5D7000),
                          size: 14,
                        ),
                      const SizedBox(width: 4),
                      Text(
                        record['status'],
                        style: TextStyle(
                          color: Color(record['textColor'] as int),
                          fontSize: 12,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tensi, Suhu, and Dropdown Icon
            InkWell(
              onTap: () {
                // Jika ada detail (symptoms/notes), toggle expand
                if (hasDetails) {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Tensi ${record['tensi']} ',
                              style: const TextStyle(
                                color: Color(0xFF1C1B1C),
                                fontSize: 18,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w600,
                                height: 1.56,
                              ),
                            ),
                            const TextSpan(
                              text: '• ',
                              style: TextStyle(
                                color: Color(0xFF1C1B1C),
                                fontSize: 18,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w700,
                                height: 1.56,
                              ),
                            ),
                            TextSpan(
                              text: 'Suhu ${record['suhu']}',
                              style: const TextStyle(
                                color: Color(0xFF1C1B1C),
                                fontSize: 18,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w600,
                                height: 1.56,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Ganti icon berdasarkan state _isExpanded
                    if (hasDetails)
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF1C1B1C),
                      ),
                  ],
                ),
              ),
            ),

            // Animasi ringan untuk buka tutup
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.topCenter,
              curve: Curves.easeInOut,
              child: !_isExpanded
                  ? const SizedBox(width: double.infinity)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: Color(0x7FC8C5CB), height: 32),

                        if (hasSymptoms)
                          Wrap(
                            runSpacing: 8,
                            children: (record['symptoms'] as List<String>).map((
                              symptom,
                            ) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE2E2E2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                ),
                                child: Text(
                                  symptom,
                                  style: const TextStyle(
                                    color: Color(0xFF63646C),
                                    fontSize: 12,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w600,
                                    height: 1.33,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                        if (hasSymptoms) const SizedBox(height: 12),

                        if (hasNotes) ...[
                          const Text(
                            'CATATAN CAREGIVER',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 12,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                              height: 1.33,
                              letterSpacing: 0.60,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            record['notes'],
                            style: const TextStyle(
                              color: Color(0xFF1C1B1C),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ],

                        const Divider(color: Color(0x7FC8C5CB), height: 32),

                        InkWell(
                          onTap: () {
                            final ctrl = Get.find<PatientDetailController>();
                            Get.toNamed(Routes.DETAIL_HISTORY, arguments: {
                              'elderly_id': ctrl.elderlyId,
                              'name': ctrl.patientName,
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lihat Riwayat Kesehatan',
                                  style: TextStyle(
                                    color: Color(0xFF1C1B1C),
                                    fontSize: 16,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF1C1B1C),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
