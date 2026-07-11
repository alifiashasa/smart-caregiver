import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      key: const Key('edit_profile_scaffold'),
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Edit Profil'),
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
            padding: EdgeInsets.fromLTRB(pagePadding, 24, pagePadding, 40),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: AppTheme.cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informasi Profil', style: textTheme.titleMedium),
                    const SizedBox(height: 24),
                    TextField(
                      key: const Key('edit_name_field'),
                      controller: controller.nameController,
                      decoration: AppTheme.inputDecoration(
                        hintText: 'Nama lengkap',
                        labelText: 'Nama Lengkap',
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      key: const Key('edit_phone_field'),
                      controller: controller.phoneController,
                      decoration: AppTheme.inputDecoration(
                        hintText: 'Nomor telepon',
                        labelText: 'Telepon',
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => controller.save(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => FilledButton.icon(
                key: const Key('edit_save_button'),
                onPressed: controller.isSaving || !controller.hasChanges
                    ? null
                    : controller.save,
                icon: controller.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_rounded, size: 20),
                label: Text(
                  controller.isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                ),
              )),
            ],
          );
        }),
      ),
    );
  }
}
