import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/log_kesehatan_controller.dart';

class LogKesehatanView extends GetView<LogKesehatanController> {
  const LogKesehatanView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Isi Data Kesehatan'),
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(pagePadding, 24, pagePadding, 40),
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildVisitInfoCard(context),
            const SizedBox(height: 20),
            _buildVitalsCard(context),
            const SizedBox(height: 20),
            _buildNotesCard(context),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data Kesehatan', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Catat tanda vital dan kondisi keseluruhan hari ini. Isi hanya data yang tersedia.',
          style: textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
        ),
      ],
    );
  }

  Widget _buildVisitInfoCard(BuildContext context) {
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(radius: 20, elevated: false),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoPill(
              context: context,
              icon: Icons.calendar_today_rounded,
              label: _weekdayFull(now),
              value: '${now.day} ${_monthName(now.month)} ${now.year}',
            ),
          ),
          Container(
            width: 1,
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: AppTheme.border,
          ),
          Expanded(
            child: Obx(
              () => _buildInfoPill(
                context: context,
                icon: Icons.person_rounded,
                label: 'Pasien',
                value: controller.patientName.isEmpty
                    ? 'Belum dipilih'
                    : controller.patientName,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTheme.accentSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 19, color: AppTheme.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVitalsCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanda Vital', style: textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Gunakan angka sesuai alat ukur.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceMuted,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Opsional',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildVitalRow(
            icon: Icons.water_drop_outlined,
            iconColor: AppTheme.warning,
            iconBgColor: AppTheme.warningSoft,
            title: 'Kolesterol',
            hintValue: '180',
            unit: 'mg/dL',
            keyboardType: TextInputType.number,
            textController: controller.cholesterolController,
          ),
          _buildDivider(),
          _buildVitalRow(
            icon: Icons.favorite_border_rounded,
            iconColor: AppTheme.success,
            iconBgColor: AppTheme.successSoft,
            title: 'Tensi',
            hintValue: '120/80',
            unit: 'mmHg',
            keyboardType: TextInputType.text,
            textController: controller.tensiController,
          ),
          _buildDivider(),
          _buildVitalRow(
            icon: Icons.science_outlined,
            iconColor: AppTheme.textSecondary,
            iconBgColor: AppTheme.surfaceMuted,
            title: 'Asam Urat',
            hintValue: '5.5',
            unit: 'mg/dL',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textController: controller.uricAcidController,
          ),
          _buildDivider(),
          _buildVitalRow(
            icon: Icons.bloodtype_outlined,
            iconColor: AppTheme.error,
            iconBgColor: AppTheme.errorSoft,
            title: 'Gula Darah',
            hintValue: '98.6',
            unit: 'mg/dL',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textController: controller.bloodSugarController,
          ),
          _buildDivider(),
          _buildVitalRow(
            icon: Icons.device_thermostat_outlined,
            iconColor: AppTheme.textSecondary,
            iconBgColor: AppTheme.surfaceMuted,
            title: 'Suhu',
            hintValue: '36.5',
            unit: '°C',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textController: controller.bodyTempController,
          ),
          _buildDivider(),
          _buildVitalRow(
            icon: Icons.monitor_heart_outlined,
            iconColor: AppTheme.success,
            iconBgColor: AppTheme.successSoft,
            title: 'Detak Jantung',
            hintValue: '72',
            unit: 'bpm',
            keyboardType: TextInputType.number,
            textController: controller.heartRateController,
          ),
          _buildDivider(),
          _buildVitalRow(
            icon: Icons.air_rounded,
            iconColor: AppTheme.warning,
            iconBgColor: AppTheme.warningSoft,
            title: 'Saturasi',
            hintValue: '98',
            unit: '%',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textController: controller.spo2Controller,
          ),
          _buildDivider(),
          _buildVitalRow(
            icon: Icons.monitor_weight_outlined,
            iconColor: AppTheme.textSecondary,
            iconBgColor: AppTheme.surfaceMuted,
            title: 'Berat Badan',
            hintValue: '70',
            unit: 'kg',
            keyboardType: TextInputType.number,
            textController: controller.weightController,
          ),
        ],
      ),
    );
  }

  Widget _buildVitalRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String hintValue,
    required String unit,
    required TextInputType keyboardType,
    required TextEditingController textController,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Get.textTheme.labelLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 92,
            child: TextField(
              controller: textController,
              textAlign: TextAlign.right,
              keyboardType: keyboardType,
              textInputAction: TextInputAction.next,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              decoration: InputDecoration(
                hintText: hintValue,
                hintStyle: Get.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textTertiary.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w700,
                ),
                filled: true,
                fillColor: AppTheme.surfaceMuted,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 44,
            child: Text(
              unit,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Get.textTheme.labelMedium?.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Catatan Tambahan', style: textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            'Tambahkan keluhan atau observasi harian untuk membantu analisis.',
            style: textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.complaintsController,
            maxLines: 3,
            decoration: AppTheme.inputDecoration(
              labelText: 'Keluhan',
              hintText: 'Contoh: pusing, lemas, nyeri sendi',
              prefixIcon: const Icon(Icons.sick_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: controller.notesController,
            maxLines: 4,
            decoration: AppTheme.inputDecoration(
              labelText: 'Catatan Caregiver',
              hintText: 'Ada catatan aktivitas, makan, atau perilaku hari ini?',
              prefixIcon: const Icon(Icons.note_alt_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading ? null : controller.submitHealthRecord,
        child: AnimatedSwitcher(
          duration: AppTheme.motionFast,
          child: controller.isLoading
              ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(key: ValueKey('label'), 'Simpan Data Kesehatan'),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: AppTheme.border);
  }

  String _weekdayFull(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[date.weekday - 1];
  }

  String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }
}
