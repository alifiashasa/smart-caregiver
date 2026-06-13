import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/tambah_lansia_controller.dart';

class TambahLansiaView extends GetView<TambahLansiaController> {
  const TambahLansiaView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Tambah Lansia Baru'),
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
            _buildIntro(context),
            const SizedBox(height: 20),
            _buildBasicInfoCard(context),
            const SizedBox(height: 18),
            _buildHealthBackgroundCard(context),
            const SizedBox(height: 18),
            _buildPersonalCard(context),
            const SizedBox(height: 24),
            _buildFooterActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profil Pasien', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Lengkapi data dasar agar pemantauan, jadwal, dan rekomendasi lebih akurat.',
          style: textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
        ),
      ],
    );
  }

  Widget _buildBasicInfoCard(BuildContext context) {
    return _buildCard(
      context: context,
      icon: Icons.badge_outlined,
      title: 'Informasi Dasar',
      subtitle: 'Identitas utama pasien.',
      children: [
        _buildPhotoPicker(context),
        const SizedBox(height: 22),
        TextFormField(
          onChanged: (value) => controller.namaLengkap = value,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          decoration: AppTheme.inputDecoration(
            labelText: 'Nama Lengkap',
            hintText: 'Masukkan nama lengkap',
            prefixIcon: const Icon(Icons.person_outline_rounded),
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          onChanged: (value) => controller.usia = value,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: AppTheme.inputDecoration(
            labelText: 'Usia (Tahun)',
            hintText: 'Contoh: 75',
            prefixIcon: const Icon(Icons.cake_outlined),
          ),
        ),
        const SizedBox(height: 18),
        _buildSectionLabel(context, 'Jenis Kelamin'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildChoiceChip(
                title: 'Laki-laki',
                groupValue: controller.jenisKelamin,
                selectedColor: AppTheme.primary,
                selectedTextColor: Colors.white,
                centerText: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildChoiceChip(
                title: 'Perempuan',
                groupValue: controller.jenisKelamin,
                selectedColor: AppTheme.primary,
                selectedTextColor: Colors.white,
                centerText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoPicker(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Semantics(
        button: true,
        label: 'Unggah foto profil pasien',
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: controller.pickImage,
            child: Column(
              children: [
                Obx(
                  () => Container(
                    width: 104,
                    height: 104,
                    padding: controller.fotoProfilBytes == null
                        ? const EdgeInsets.all(0)
                        : EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceMuted,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.border, width: 2),
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: controller.fotoProfilBytes == null
                        ? const Icon(
                            Icons.add_a_photo_outlined,
                            color: AppTheme.textTertiary,
                            size: 34,
                          )
                        : Image.memory(
                            controller.fotoProfilBytes!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Unggah Foto Profil',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthBackgroundCard(BuildContext context) {
    return _buildCard(
      context: context,
      icon: Icons.health_and_safety_outlined,
      title: 'Latar Belakang Kesehatan',
      subtitle: 'Kondisi umum untuk kebutuhan perawatan harian.',
      children: [
        TextFormField(
          onChanged: (value) => controller.riwayatMedis = value,
          maxLines: 3,
          decoration: AppTheme.inputDecoration(
            labelText: 'Riwayat Medis',
            hintText: 'Contoh: hipertensi, diabetes',
            prefixIcon: const Icon(Icons.medical_information_outlined),
          ),
        ),
        const SizedBox(height: 18),
        _buildSectionLabel(context, 'Kondisi Fisik'),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildChoiceChip(
              title: 'Mandiri',
              groupValue: controller.kondisiFisik,
              selectedColor: AppTheme.accent,
              selectedTextColor: AppTheme.primary,
              centerText: true,
            ),
            const SizedBox(height: 8),
            _buildChoiceChip(
              title: 'Butuh Bantuan Sebagian',
              groupValue: controller.kondisiFisik,
              selectedColor: AppTheme.accent,
              selectedTextColor: AppTheme.primary,
              centerText: true,
            ),
            const SizedBox(height: 8),
            _buildChoiceChip(
              title: 'Butuh Bantuan Penuh',
              groupValue: controller.kondisiFisik,
              selectedColor: AppTheme.accent,
              selectedTextColor: AppTheme.primary,
              centerText: true,
            ),
          ],
        ),
        const SizedBox(height: 18),
        _buildSectionLabel(context, 'Tingkat Mobilitas'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChoiceChip(
              title: 'Bisa Berjalan',
              groupValue: controller.mobilitas,
              selectedColor: AppTheme.accent,
              selectedTextColor: AppTheme.primary,
            ),
            _buildChoiceChip(
              title: 'Alat Bantu',
              groupValue: controller.mobilitas,
              selectedColor: AppTheme.accent,
              selectedTextColor: AppTheme.primary,
            ),
            _buildChoiceChip(
              title: 'Kursi Roda',
              groupValue: controller.mobilitas,
              selectedColor: AppTheme.accent,
              selectedTextColor: AppTheme.primary,
            ),
            _buildChoiceChip(
              title: 'Berbaring',
              groupValue: controller.mobilitas,
              selectedColor: AppTheme.accent,
              selectedTextColor: AppTheme.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _buildCard(
      context: context,
      icon: Icons.interests_outlined,
      title: 'Personal & Minat',
      subtitle: 'Preferensi yang membantu rekomendasi aktivitas.',
      children: [
        TextFormField(
          onChanged: (value) => controller.minatHobi = value,
          maxLines: 3,
          decoration: AppTheme.inputDecoration(
            labelText: 'Minat dan Hobi',
            hintText: 'Contoh: musik, berkebun, membaca',
            prefixIcon: const Icon(Icons.favorite_border_rounded),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.accentSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Informasi ini dipakai untuk membuat rekomendasi aktivitas AI yang lebih personal.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.titleLarge),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: AppTheme.textSecondary),
    );
  }

  Widget _buildChoiceChip({
    required String title,
    required RxString groupValue,
    required Color selectedColor,
    required Color selectedTextColor,
    bool centerText = false,
  }) {
    return Obx(() {
      final isSelected = groupValue.value == title;
      return Semantics(
        button: true,
        selected: isSelected,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            onTap: () => groupValue.value = title,
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: AppTheme.motionFast,
              curve: Curves.easeOutCubic,
              constraints: const BoxConstraints(minHeight: 44),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: isSelected ? selectedColor : AppTheme.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isSelected ? selectedColor : AppTheme.borderStrong,
                ),
              ),
              width: centerText ? double.infinity : null,
              alignment: centerText ? Alignment.center : null,
              child: Text(
                title,
                textAlign: centerText ? TextAlign.center : null,
                style: Get.textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? selectedTextColor
                      : AppTheme.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFooterActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading ? null : controller.simpan,
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
                  : const Text(key: ValueKey('label'), 'Simpan Data'),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
      ],
    );
  }
}
