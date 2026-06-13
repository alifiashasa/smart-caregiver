import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/profil_lansia_controller.dart';

class ProfilLansiaView extends GetView<ProfilLansiaController> {
  const ProfilLansiaView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Profil Lansia'),
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(pagePadding, 24, pagePadding, 112),
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildTabs(context),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: AppTheme.motion,
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: controller.selectedProfileTab == 0
                    ? _buildBasicInfo(context)
                    : _buildHealthBackground(context),
              ),
              const SizedBox(height: 24),
              _buildSaveButton(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Obx(
              () => Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppTheme.accentSoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: AppTheme.softShadow,
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildPatientImage(controller.patientImage),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.background, width: 3),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          controller.namaController.text.isEmpty
              ? 'Profil Lansia'
              : controller.namaController.text,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${controller.umurController.text.isEmpty ? '-' : '${controller.umurController.text} Tahun'} • ${controller.jenisKelaminController.text.isEmpty ? '-' : controller.jenisKelaminController.text}',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
        ),
      ],
    );
  }

  Widget _buildPatientImage(String source) {
    if (source.startsWith('http')) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person_rounded, color: AppTheme.primary, size: 44),
      );
    }

    return Image.asset(
      source,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.person_rounded, color: AppTheme.primary, size: 44),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          _buildTab(context, index: 0, label: 'Informasi'),
          _buildTab(context, index: 1, label: 'Kesehatan'),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required int index,
    required String label,
  }) {
    final selected = controller.selectedProfileTab == index;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => controller.changeProfileTab(index),
          child: AnimatedContainer(
            duration: AppTheme.motionFast,
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: selected ? AppTheme.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: textTheme.labelLarge?.copyWith(
                color: selected ? AppTheme.primary : AppTheme.textTertiary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    return _buildSection(
      context: context,
      key: const ValueKey('basic'),
      title: 'Informasi Dasar',
      subtitle: 'Data identitas utama pasien lansia.',
      children: [
        _buildTextField(
          context,
          label: 'Nama Lengkap',
          controller: controller.namaController,
          icon: Icons.person_outline_rounded,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                context,
                label: 'Umur',
                controller: controller.umurController,
                icon: Icons.cake_outlined,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                context,
                label: 'Jenis Kelamin',
                controller: controller.jenisKelaminController,
                icon: Icons.wc_rounded,
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthBackground(BuildContext context) {
    return _buildSection(
      context: context,
      key: const ValueKey('health'),
      title: 'Latar Belakang Kesehatan',
      subtitle:
          'Riwayat medis serta minat yang membantu rekomendasi aktivitas.',
      children: [
        _buildTextField(
          context,
          label: 'Riwayat Medis',
          controller: controller.riwayatMedisController,
          icon: Icons.medical_information_outlined,
          minLines: 4,
          maxLines: 5,
          textInputAction: TextInputAction.newline,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          context,
          label: 'Minat dan Hobi',
          controller: controller.minatHobiController,
          icon: Icons.favorite_border_rounded,
          minLines: 3,
          maxLines: 4,
          textInputAction: TextInputAction.newline,
        ),
      ],
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required Key key,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      key: key,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration(radius: AppTheme.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
          ),
          const SizedBox(height: 22),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    int minLines = 1,
    int maxLines = 1,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          minLines: minLines,
          maxLines: maxLines,
          style: textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration:
              AppTheme.inputDecoration(
                labelText: null,
                hintText: label,
                prefixIcon: Icon(icon),
              ).copyWith(
                filled: true,
                fillColor: AppTheme.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: AppTheme.primary,
                    width: 1.3,
                  ),
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading ? null : controller.saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
        ),
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
              : const Text(key: ValueKey('label'), 'Simpan Perubahan'),
        ),
      ),
    );
  }
}
