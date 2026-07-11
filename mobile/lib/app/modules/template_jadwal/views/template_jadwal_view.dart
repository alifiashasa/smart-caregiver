import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/template_jadwal_controller.dart';

class TemplateJadwalView extends GetView<TemplateJadwalController> {
  const TemplateJadwalView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);

    return Scaffold(
      key: const Key('template_jadwal_scaffold'),
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Pilih Template'),
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(pagePadding, 24, pagePadding, 24),
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 22),
                  Obx(
                  () => Column(
                    key: const Key('template_list_column'),
                      children: controller.templates
                          .map(
                            (template) => _buildTemplateCard(context, template),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomAction(context),
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
        Text('Template Jadwal Rutin', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Pilih kegiatan yang ingin ditambahkan ke jadwal hari ini.',
          style: textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
        ),
      ],
    );
  }

  Widget _buildTemplateCard(BuildContext context, TemplateJadwal template) {
    final textTheme = Theme.of(context).textTheme;
    final style = _typeStyle(template.scheduleType);

    return Obx(() {
      final selected = template.isEnabled.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: InkWell(
            onTap: () => template.isEnabled.value = !selected,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(
                borderColor: selected ? AppTheme.accent : AppTheme.border,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: style.softColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(style.icon, color: style.color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 15,
                              color: AppTheme.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              template.time,
                              style: textTheme.labelMedium?.copyWith(
                                color: AppTheme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Text(
                          template.title,
                          style: textTheme.titleMedium?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          template.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch.adaptive(
                    value: selected,
                    onChanged: (value) => template.isEnabled.value = value,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppTheme.pagePadding(context),
        16,
        AppTheme.pagePadding(context),
        16,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Obx(
        () => ElevatedButton(
          key: const Key('add_template_button'),
          onPressed: controller.isLoading
              ? null
              : controller.saveTemplateSchedule,
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
                : const Text(key: ValueKey('label'), 'Tambahkan ke Jadwal'),
          ),
        ),
      ),
    );
  }

  _TemplateTypeStyle _typeStyle(String type) {
    switch (type) {
      case 'medication':
        return const _TemplateTypeStyle(
          icon: Icons.medication_outlined,
          color: AppTheme.error,
          softColor: AppTheme.errorSoft,
        );
      case 'routine_checkup':
        return const _TemplateTypeStyle(
          icon: Icons.health_and_safety_outlined,
          color: AppTheme.success,
          softColor: AppTheme.successSoft,
        );
      default:
        return const _TemplateTypeStyle(
          icon: Icons.directions_walk_rounded,
          color: AppTheme.warning,
          softColor: AppTheme.warningSoft,
        );
    }
  }
}

class _TemplateTypeStyle {
  final IconData icon;
  final Color color;
  final Color softColor;

  const _TemplateTypeStyle({
    required this.icon,
    required this.color,
    required this.softColor,
  });
}
