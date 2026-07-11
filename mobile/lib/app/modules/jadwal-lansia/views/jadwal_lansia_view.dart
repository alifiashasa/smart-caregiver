import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/jadwal_lansia_controller.dart';

class JadwalLansiaView extends GetView<JadwalLansiaController> {
  const JadwalLansiaView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);

    return Scaffold(
      key: const Key('jadwal_lansia_scaffold'),
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Jadwal Caregiver'),
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
            _buildFormCard(context),
            const SizedBox(height: 24),
            _buildSaveButton(),
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
        Text('Tambah Kegiatan', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Buat pengingat perawatan, aktivitas harian, atau pemeriksaan rutin.',
          style: textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
        ),
      ],
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            key: const Key('schedule_title_field'),
            controller: controller.titleController,
            textInputAction: TextInputAction.next,
            decoration: AppTheme.inputDecoration(
              labelText: 'Nama Aktivitas',
              hintText: 'Contoh: Jalan pagi, minum obat',
              prefixIcon: const Icon(Icons.edit_calendar_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            key: const Key('schedule_description_field'),
            controller: controller.descriptionController,
            maxLines: 3,
            decoration: AppTheme.inputDecoration(
              labelText: 'Deskripsi',
              hintText: 'Catatan singkat untuk kegiatan ini (opsional)',
              prefixIcon: const Icon(Icons.notes_outlined),
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel(context, 'Tipe Kegiatan'),
          const SizedBox(height: 10),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: JadwalLansiaController.typeOptions.map((option) {
                final value = option['value'] as String;
                final label = option['label'] as String;
                final icon = option['icon'] as IconData;
                final isSelected = controller.selectedType == value;
                return _buildTypeChip(
                  label: label,
                  icon: icon,
                  isSelected: isSelected,
                  onTap: () => controller.selectType(value, label),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => _buildPickerField(
              context: context,
              label: 'Tanggal',
              value: controller.dateDisplay,
              icon: Icons.calendar_today_rounded,
              onTap: _pickDate,
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => _buildPickerField(
              context: context,
              label: 'Waktu',
              value: controller.timeDisplay,
              icon: Icons.access_time_rounded,
              onTap: _pickTime,
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => _buildPickerField(
              context: context,
              label: 'Mengulang',
              value: controller.recurrenceLabel,
              icon: Icons.repeat_rounded,
              onTap: _pickRecurrence,
            ),
          ),
          const SizedBox(height: 20),
          _buildAlarmSection(context),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: AppTheme.textSecondary),
    );
  }

  Widget _buildTypeChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: AppTheme.motionFast,
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primary : AppTheme.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isSelected ? AppTheme.primary : AppTheme.borderStrong,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Get.textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickerField({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, label),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Ink(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: AppTheme.cardDecoration(
                radius: 18,
                elevated: false,
                borderColor: AppTheme.borderStrong,
              ),
              child: Row(
                children: [
                  Icon(icon, color: AppTheme.textSecondary, size: 21),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value,
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlarmSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Obx(
      () => Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => controller.toggleAlarm(!controller.alarmEnabled),
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration(
              radius: 20,
              elevated: false,
              borderColor: controller.alarmEnabled
                  ? AppTheme.accent
                  : AppTheme.border,
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppTheme.accentSoft,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: AppTheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pemberitahuan Alarm', style: textTheme.titleMedium),
                      const SizedBox(height: 3),
                      Text(
                        '${controller.reminderMinutes} menit sebelum kegiatan',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  key: const Key('alarm_switch'),
                  value: controller.alarmEnabled,
                  onChanged: controller.toggleAlarm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => ElevatedButton(
        key: const Key('save_schedule_button'),
        onPressed: controller.isLoading ? null : controller.saveSchedule,
        child: AnimatedSwitcher(
          duration: AppTheme.motionFast,
          child: controller.isLoading
              ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(key: ValueKey('label'), 'Simpan Jadwal'),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.selectDate(picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: controller.selectedTime,
    );
    if (picked != null) {
      controller.selectTime(picked);
    }
  }

  void _pickRecurrence() {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: AppTheme.borderStrong,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Text('Frekuensi Pengulangan', style: Get.textTheme.titleLarge),
              const SizedBox(height: 12),
              ...JadwalLansiaController.recurrenceOptions.map((option) {
                final value = option['value'] as String;
                final label = option['label'] as String;
                final isSelected = controller.selectedRecurrence == value;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 10,
                  title: Text(
                    label,
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded, color: AppTheme.primary)
                      : null,
                  onTap: () {
                    controller.selectRecurrence(value);
                    Get.back();
                  },
                );
              }),
            ],
          ),
        ),
      ),
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    );
  }
}
