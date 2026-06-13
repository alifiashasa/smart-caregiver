import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detail_history_controller.dart';

class DetailHistoryView extends GetView<DetailHistoryController> {
  const DetailHistoryView({super.key});

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
          'Detail Riwayat Kesehatan',
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
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.records.isEmpty) {
            return _buildEmptyState();
          }

          return _buildContent();
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.health_and_safety_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada data kesehatan',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF77767B),
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 961),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFFFDF8F8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 20,
                  right: 20,
                  bottom: 48,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 16),
                    _buildRecordSelector(),
                    const SizedBox(height: 24),
                    _buildMetricsCard(),
                    if (controller.fuzzyAnalysis != null) ...[
                      const SizedBox(height: 24),
                      _buildFuzzyAnalysisCard(),
                    ],
                    const SizedBox(height: 24),
                    _buildNotesSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
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
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Flexible(
                    child: Text(
                      controller.patientName.isNotEmpty
                          ? controller.patientName
                          : 'Riwayat Kesehatan',
                      style: const TextStyle(
                        color: Color(0xFF4C4546),
                        fontSize: 14,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                        height: 1.43,
                        letterSpacing: 0.14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusBadge(),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => Text(
                controller.selectedRecordDate.isNotEmpty
                    ? controller.selectedRecordDate
                    : 'Riwayat kesehatan dan pemantauan tanda vital',
                style: const TextStyle(
                  color: Color(0xFF47464B),
                  fontSize: 14,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Obx(() {
      final status = controller.healthStatus;
      if (status == null) return const SizedBox.shrink();

      Color badgeColor;
      Color textColor;
      IconData icon;
      String label;

      switch (status) {
        case 'Normal':
          badgeColor = const Color(0xFFD6E7D0);
          textColor = const Color(0xFF4C9A2A);
          icon = Icons.check_circle;
          label = 'Normal';
          break;
        case 'Warning':
          badgeColor = const Color(0xFFFFEFC7);
          textColor = const Color(0xFFB8860B);
          icon = Icons.warning_amber;
          label = 'Perlu Perhatian';
          break;
        case 'Critical':
          badgeColor = const Color(0xFFFDDCC9);
          textColor = const Color(0xFFD31822);
          icon = Icons.error;
          label = 'Kritis';
          break;
        default:
          badgeColor = const Color(0xFFE2E2E2);
          textColor = const Color(0xFF192126);
          icon = Icons.info;
          label = status;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: ShapeDecoration(
          color: badgeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRecordSelector() {
    return Obx(() {
      if (controller.records.length <= 1) return const SizedBox.shrink();

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: controller.selectedIndex > 0
                ? () => controller.selectRecord(controller.selectedIndex - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
            color: controller.selectedIndex > 0
                ? const Color(0xFF1C1B1C)
                : Colors.grey.shade300,
          ),
          const SizedBox(width: 8),
          Text(
            '${controller.selectedIndex + 1} / ${controller.records.length}',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1B1C),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: controller.selectedIndex < controller.records.length - 1
                ? () => controller.selectRecord(controller.selectedIndex + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
            color: controller.selectedIndex < controller.records.length - 1
                ? const Color(0xFF1C1B1C)
                : Colors.grey.shade300,
          ),
        ],
      );
    });
  }

  Widget _buildMetricsCard() {
    return Obx(() {
      final rec = controller.selectedRecord;
      if (rec == null) return const SizedBox.shrink();

      // Collect non-null metric items dynamically
      final metrics = <_MetricItem>[];

      // Tensi (systolic_bp / diastolic_bp)
      final sys = rec['systolic_bp'];
      final dia = rec['diastolic_bp'];
      if (sys != null || dia != null) {
        final val = sys != null && dia != null
            ? '${_fmtNum(sys)}/${_fmtNum(dia)}'
            : (sys != null ? _fmtNum(sys)! : '—/${_fmtNum(dia)}');
        metrics.add(
          _MetricItem(
            title: 'Tensi',
            value: val,
            unit: 'mmHg',
            iconBgColor: const Color(0xFFD6E7D0),
            iconData: Icons.favorite,
            iconColor: const Color(0xFF4C9A2A),
          ),
        );
      }

      // Detak Jantung (heart_rate)
      if (rec['heart_rate'] != null) {
        final hr = _fmtNum(rec['heart_rate']);
        final isHigh =
            (rec['heart_rate'] as num) > 100 || (rec['heart_rate'] as num) < 60;
        metrics.add(
          _MetricItem(
            title: 'Detak Jantung',
            value: hr!,
            unit: 'bpm',
            iconBgColor: isHigh
                ? const Color(0xFFFDDCC9)
                : const Color(0xFFD6E7D0),
            iconData: Icons.monitor_heart,
            iconColor: isHigh
                ? const Color(0xFFD31822)
                : const Color(0xFF4C9A2A),
          ),
        );
      }

      // Saturasi (spo2_level)
      if (rec['spo2_level'] != null) {
        final spo2 = _fmtNum(rec['spo2_level']);
        final isLow = (rec['spo2_level'] as num) < 95;
        metrics.add(
          _MetricItem(
            title: 'Saturasi',
            value: spo2!,
            unit: '%',
            iconBgColor: isLow
                ? const Color(0xFFFDDCC9)
                : const Color(0xFFD6E7D0),
            iconData: Icons.air,
            iconColor: isLow
                ? const Color(0xFFD31822)
                : const Color(0xFF4C9A2A),
          ),
        );
      }

      // Gula Darah (blood_sugar)
      if (rec['blood_sugar'] != null) {
        final bs = _fmtNum(rec['blood_sugar']);
        final isHigh = (rec['blood_sugar'] as num) > 140;
        metrics.add(
          _MetricItem(
            title: 'Gula Darah',
            value: bs!,
            unit: 'mg/dL',
            iconBgColor: isHigh
                ? const Color(0xFFFFDAD6)
                : const Color(0xFFD6E7D0),
            iconData: Icons.water_drop,
            iconColor: isHigh
                ? const Color(0xFFD31822)
                : const Color(0xFF4C9A2A),
          ),
        );
      }

      // Kolestrol (cholesterol)
      if (rec['cholesterol'] != null) {
        final chol = _fmtNum(rec['cholesterol']);
        final isHigh = (rec['cholesterol'] as num) > 200;
        metrics.add(
          _MetricItem(
            title: 'Kolestrol',
            value: chol!,
            unit: 'mg/dL',
            iconBgColor: isHigh
                ? const Color(0xFFFDDCC9)
                : const Color(0xFFD6E7D0),
            iconData: Icons.bloodtype,
            iconColor: isHigh
                ? const Color(0xFFD31822)
                : const Color(0xFF4C9A2A),
          ),
        );
      }

      // Asam Urat (uric_acid)
      if (rec['uric_acid'] != null) {
        final ua = _fmtNum(rec['uric_acid']);
        final isHigh = (rec['uric_acid'] as num) > 7.0;
        metrics.add(
          _MetricItem(
            title: 'Asam Urat',
            value: ua!,
            unit: 'mg/dL',
            iconBgColor: isHigh
                ? const Color(0xFFFFDAD6)
                : const Color(0xFFEEEEEE),
            iconData: Icons.science,
            iconColor: isHigh
                ? const Color(0xFFD31822)
                : const Color(0xFF1C1B1C),
          ),
        );
      }

      // Suhu (body_temperature)
      if (rec['body_temperature'] != null) {
        final temp = _fmtNum(rec['body_temperature']);
        final tempVal = (rec['body_temperature'] as num);
        final isAbnormal = tempVal >= 37.5 || tempVal <= 35.5;
        metrics.add(
          _MetricItem(
            title: 'Suhu',
            value: '$temp°C',
            unit: '',
            iconBgColor: isAbnormal
                ? const Color(0xFFFFDAD6)
                : const Color(0xFFE2E2E2),
            iconData: Icons.thermostat,
            iconColor: isAbnormal
                ? const Color(0xFFD31822)
                : const Color(0xFF1C1B1C),
          ),
        );
      }

      // Berat Badan (body_weight)
      if (rec['body_weight'] != null) {
        final bw = _fmtNum(rec['body_weight']);
        metrics.add(
          _MetricItem(
            title: 'Berat Badan',
            value: bw!,
            unit: 'Kg',
            iconBgColor: const Color(0xFFEEEEEE),
            iconData: Icons.monitor_weight,
            iconColor: const Color(0xFF1C1B1C),
          ),
        );
      }

      if (metrics.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
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
          child: const Text(
            'Tidak ada data pengukuran',
            style: TextStyle(
              color: Color(0xFF77767B),
              fontSize: 14,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }

      return Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: metrics
              .map(
                (m) => _buildMetricItem(
                  m.title,
                  m.value,
                  m.unit,
                  m.iconBgColor,
                  m.iconData,
                  m.iconColor,
                ),
              )
              .toList(),
        ),
      );
    });
  }

  Widget _buildFuzzyAnalysisCard() {
    return Obx(() {
      final fuzzy = controller.fuzzyAnalysis;
      if (fuzzy == null) return const SizedBox.shrink();

      final finalScore = fuzzy['final_score']?.toStringAsFixed(2) ?? '—';
      final finalStatus = fuzzy['final_status'] as String? ?? 'Unknown';
      final cardio = fuzzy['cardiovascular'] as Map<String, dynamic>?;
      final metabolic = fuzzy['metabolic'] as Map<String, dynamic>?;
      final infection = fuzzy['infection'] as Map<String, dynamic>?;

      return Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section title
              Row(
                children: [
                  const Icon(
                    Icons.analytics_outlined,
                    size: 20,
                    color: Color(0xFF1C1B1C),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Analisis Fuzzy',
                    style: TextStyle(
                      color: Color(0xFF1C1B1C),
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  _buildFuzzyStatusBadge(finalStatus),
                ],
              ),
              const SizedBox(height: 16),

              // Final score row
              Row(
                children: [
                  const Text(
                    'Skor Akhir',
                    style: TextStyle(
                      color: Color(0xFF77767B),
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    finalScore,
                    style: TextStyle(
                      color: _statusColor(finalStatus),
                      fontSize: 18,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFF1EDED), height: 1),
              const SizedBox(height: 12),

              // Module scores
              const Text(
                'Skor per Modul',
                style: TextStyle(
                  color: Color(0xFF1C1B1C),
                  fontSize: 14,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              if (cardio != null)
                _buildModuleScore(
                  'Kardiovaskular',
                  cardio['score'],
                  cardio['status'],
                  Icons.favorite,
                  const Color(0xFFD6E7D0),
                  const Color(0xFF4C9A2A),
                ),
              if (metabolic != null)
                _buildModuleScore(
                  'Metabolik',
                  metabolic['score'],
                  metabolic['status'],
                  Icons.science,
                  const Color(0xFFEEEEEE),
                  const Color(0xFF1C1B1C),
                ),
              if (infection != null)
                _buildModuleScore(
                  'Infeksi',
                  infection['score'],
                  infection['status'],
                  Icons.thermostat,
                  const Color(0xFFE2E2E2),
                  const Color(0xFF1C1B1C),
                ),

              if (cardio == null && metabolic == null && infection == null)
                const Text(
                  'Tidak ada data modul',
                  style: TextStyle(
                    color: Color(0xFF77767B),
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildModuleScore(
    String label,
    dynamic score,
    dynamic status,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    final scoreStr = score?.toStringAsFixed(2) ?? '—';
    final statusStr = status?.toString() ?? '—';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: ShapeDecoration(
              color: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Center(child: Icon(icon, size: 16, color: iconColor)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF1C1B1C),
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  statusStr,
                  style: TextStyle(
                    color: _statusColor(statusStr),
                    fontSize: 12,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            scoreStr,
            style: TextStyle(
              color: _statusColor(statusStr),
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuzzyStatusBadge(String status) {
    Color badgeColor;
    Color textColor;

    switch (status) {
      case 'Normal':
        badgeColor = const Color(0xFFD6E7D0);
        textColor = const Color(0xFF4C9A2A);
        break;
      case 'Warning':
        badgeColor = const Color(0xFFFFEFC7);
        textColor = const Color(0xFFB8860B);
        break;
      case 'Critical':
        badgeColor = const Color(0xFFFDDCC9);
        textColor = const Color(0xFFD31822);
        break;
      default:
        badgeColor = const Color(0xFFE2E2E2);
        textColor = const Color(0xFF192126);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: ShapeDecoration(
        color: badgeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Obx(() {
      final rec = controller.selectedRecord;
      if (rec == null) return const SizedBox.shrink();

      final dailyNotes = rec['daily_notes'] as String?;
      final complaints = rec['complaints'] as String?;

      final hasNotes =
          (dailyNotes != null && dailyNotes.trim().isNotEmpty) ||
          (complaints != null && complaints.trim().isNotEmpty);

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 4),
              child: const Text(
                'Catatan',
                style: TextStyle(
                  color: Color(0xFF1C1B1C),
                  fontSize: 14,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                  letterSpacing: 0.14,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFC8C5CB)),
                  borderRadius: BorderRadius.circular(12),
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
              child: hasNotes
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (complaints != null &&
                            complaints.trim().isNotEmpty) ...[
                          _buildNoteSection(
                            'Keluhan',
                            complaints,
                            Icons.volume_up,
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (dailyNotes != null && dailyNotes.trim().isNotEmpty)
                          _buildNoteSection(
                            'Catatan Harian',
                            dailyNotes,
                            Icons.note_alt_outlined,
                          ),
                      ],
                    )
                  : const Text(
                      'Tidak ada catatan',
                      style: TextStyle(
                        color: Color(0xFF77767B),
                        fontSize: 14,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNoteSection(String label, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF77767B)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF77767B),
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            color: Color(0xFF1C1B1C),
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem(
    String title,
    String value,
    String unit,
    Color iconBgColor,
    IconData iconData,
    Color iconColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFF1EDED)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: ShapeDecoration(
                  color: iconBgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Center(
                  child: Icon(iconData, size: 18, color: iconColor),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
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
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF1C1B1C),
                  fontSize: 16,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  unit,
                  style: const TextStyle(
                    color: Color(0xFF77767B),
                    fontSize: 12,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Normal':
        return const Color(0xFF4C9A2A);
      case 'Warning':
        return const Color(0xFFB8860B);
      case 'Critical':
        return const Color(0xFFD31822);
      default:
        return const Color(0xFF1C1B1C);
    }
  }

  /// Format a numeric value, dropping unnecessary trailing zeros.
  String? _fmtNum(dynamic val) {
    if (val == null) return null;
    final num n = val is num ? val : double.tryParse(val.toString()) ?? 0;
    if (n == n.roundToDouble()) {
      return n.toInt().toString();
    }
    return n.toStringAsFixed(1);
  }
}

/// Internal helper to hold metric item configuration.
class _MetricItem {
  final String title;
  final String value;
  final String unit;
  final Color iconBgColor;
  final IconData iconData;
  final Color iconColor;

  const _MetricItem({
    required this.title,
    required this.value,
    required this.unit,
    required this.iconBgColor,
    required this.iconData,
    required this.iconColor,
  });
}
