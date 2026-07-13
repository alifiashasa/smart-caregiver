import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/patient_detail_controller.dart';

class PatientDetailView extends GetView<PatientDetailController> {
  const PatientDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);

    return Scaffold(
      key: const Key('patient_detail_scaffold'),
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Riwayat Kesehatan'),
        leading: IconButton(
          key: const Key('detail_history_back_button'),
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingRecords) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () async {
              final id = controller.elderlyId;
              if (id != null && id.isNotEmpty) {
                await controller.loadHealthRecords(id);
              }
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(pagePadding, 24, pagePadding, 112),
              children: [
                if (controller.records.isEmpty)
                  _buildEmptyState(context)
                else
                  ...controller.records.asMap().entries.map(
                    (entry) => TimelineCard(
                      key: ValueKey('timeline_card_${entry.key}'),
                      record: entry.value,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      key: const Key('patient_detail_empty_state'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.accentSoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.monitor_heart_outlined,
              color: AppTheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 18),
          Text('Belum ada riwayat', style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Data kesehatan yang dicatat akan tampil di halaman ini.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
          ),
        ],
      ),
    );
  }
}

class TimelineCard extends StatefulWidget {
  const TimelineCard({super.key, required this.record});

  final Map<String, dynamic> record;

  @override
  State<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<TimelineCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final record = widget.record;
    final symptoms = (record['symptoms'] as List?)?.cast<String>() ?? [];
    final notes = record['notes']?.toString() ?? '';
    final isCritical = record['status'] == 'Perlu Perhatian';
    final hasDetails = symptoms.isNotEmpty || notes.isNotEmpty || isCritical;
    final textTheme = Theme.of(context).textTheme;
    final statusColor = Color(record['color'] as int? ?? 0xFFBBF246);
    final textColor = Color(record['textColor'] as int? ?? 0xFF192126);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          onTap: hasDetails
              ? () => setState(() => _isExpanded = !_isExpanded)
              : null,
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: AppTheme.cardDecoration(
              radius: AppTheme.radiusLg,
              elevated: true,
              borderColor: isCritical ? AppTheme.warningSoft : AppTheme.border,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        record['date']?.toString() ?? '-',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCritical
                                ? Icons.info_outline_rounded
                                : Icons.check_circle_outline_rounded,
                            size: 14,
                            color: textColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            record['status']?.toString() ?? '-',
                            style: textTheme.labelMedium?.copyWith(
                              color: textColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _VitalPill(
                            label: 'Tensi',
                            value: record['tensi']?.toString() ?? '—',
                            icon: Icons.bloodtype_outlined,
                          ),
                          _VitalPill(
                            label: 'Suhu',
                            value: record['suhu']?.toString() ?? '—',
                            icon: Icons.thermostat_outlined,
                          ),
                        ],
                      ),
                    ),
                    if (hasDetails) ...[
                      const SizedBox(width: 8),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppTheme.textSecondary,
                      ),
                    ],
                  ],
                ),
                AnimatedSize(
                  duration: AppTheme.motion,
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: !_isExpanded
                      ? const SizedBox(width: double.infinity)
                      : _buildDetails(context, symptoms, notes),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(
    BuildContext context,
    List<String> symptoms,
    String notes,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 30),
        if (symptoms.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: symptoms.map((symptom) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  symptom,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (notes.isNotEmpty) ...[
          Text(
            'Catatan Caregiver',
            style: textTheme.labelMedium?.copyWith(
              color: AppTheme.textTertiary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(notes, style: textTheme.bodyMedium),
          const SizedBox(height: 18),
        ],
        Material(
          color: AppTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            key: const Key('detail_history_link'),
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              final ctrl = Get.find<PatientDetailController>();
              Get.toNamed(
                Routes.DETAIL_HISTORY,
                arguments: {
                  'elderly_id': ctrl.elderlyId,
                  'name': ctrl.patientName,
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Lihat detail riwayat',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VitalPill extends StatelessWidget {
  const _VitalPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppTheme.textTertiary),
          const SizedBox(width: 8),
          Text(
            '$label ',
            style: textTheme.labelMedium?.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
          Text(
            value,
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
