import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);

    return Scaffold(
      key: const Key('home_scaffold'),
      backgroundColor: AppTheme.background,
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add_patient_fab'),
        onPressed: () async {
          final result = await Get.toNamed(Routes.TAMBAH_LANSIA);
          if (result == true) {
            controller.loadElderly();
            controller.loadUnreadCount();
          }
        },
        icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
        label: const Text('Pasien'),
      ),
      body: SafeArea(
        child: Obx(() {
          final isFirstLoad =
              controller.isLoading && controller.elderlyList.isEmpty;

          if (isFirstLoad) {
            return Column(
              children: [
                _buildTopBar(context, pagePadding),
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          }

          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () async {
              await controller.loadElderly();
              await controller.loadUnreadCount();
            },
            child: ListView(
              key: const Key('patient_list'),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(pagePadding, 16, pagePadding, 104),
              children: [
                _buildTopBar(context, 0),
                const SizedBox(height: 28),
                _buildGreeting(context),
                const SizedBox(height: 24),
                _buildStats(context),
                const SizedBox(height: 20),
                _buildSearchSurface(context),
                const SizedBox(height: 16),
                _buildFilterChips(context),
                const SizedBox(height: 28),
                _buildPatientHeader(context),
                const SizedBox(height: 16),
                if (controller.elderlyList.isEmpty)
                  _buildEmptyPatientState(context)
                else if (controller.filteredElderlyList.isEmpty)
                  _buildNoResultsState(context)
                else
                  ...controller.filteredElderlyList.map((elderly) {
                    return _buildPatientCard(
                      context: context,
                      name: elderly.fullName,
                      age: elderly.ageLabel,
                      status: HomeController.statusLabel(
                        elderly.latestHealthStatus,
                      ),
                      isCritical: elderly.needsAttention,
                      onTap: () => controller.navigateToDashboard(elderly),
                    );
                  }),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, double horizontalPadding) {
    final content = Row(
      children: [
        Semantics(
          button: true,
          label: 'Buka profil caregiver',
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              key: const Key('profile_button'),
              customBorder: const CircleBorder(),
              onTap: () => Get.toNamed(Routes.PROFIL_CAREGIVER),
              child: Ink(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/caregiver_profile.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Smart Caregiver',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Pemantauan lansia',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Semantics(
          button: true,
          label: 'Buka notifikasi',
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              key: const Key('notification_button'),
              customBorder: const CircleBorder(),
              onTap: () async {
                await Get.toNamed(Routes.NOTIFIKASI);
                controller.loadUnreadCount();
              },
              child: Ink(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.notifications_none_rounded),
                    Obx(() {
                      final count = controller.unreadCount;
                      if (count <= 0) return const SizedBox.shrink();
                      return Positioned(
                        top: 7,
                        right: 7,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: const BoxDecoration(
                            color: AppTheme.error,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            count > 99 ? '99+' : count.toString(),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

    if (horizontalPadding == 0) return content;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 16,
      ),
      child: content,
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.liftShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            child: Text(
              'Ringkasan hari ini',
              style: textTheme.labelMedium?.copyWith(
                color: AppTheme.accent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Selamat Pagi, Sari',
            style: textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Pantau status pasien, jadwal, dan notifikasi penting dari satu tempat.',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.76),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          _buildStatCard(
            context: context,
            icon: Icons.groups_2_outlined,
            iconColor: AppTheme.primary,
            iconBgColor: AppTheme.surfaceMuted,
            value: '${controller.elderlyList.length}',
            label: 'Total Pasien',
          ),
          _buildStatCard(
            context: context,
            icon: Icons.priority_high_rounded,
            iconColor: AppTheme.warning,
            iconBgColor: AppTheme.warningSoft,
            value: '${controller.needsAttentionCount}',
            label: 'Perlu Perhatian',
          ),
        ];

        if (constraints.maxWidth < 360) {
          return Column(
            children: [cards.first, const SizedBox(height: 12), cards.last],
          );
        }

        return Row(
          children: [
            Expanded(child: cards.first),
            const SizedBox(width: 12),
            Expanded(child: cards.last),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 18),
          Text(value, style: textTheme.displaySmall?.copyWith(fontSize: 30)),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSurface(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Kolom pencarian pasien',
      child: Container(
        decoration: AppTheme.cardDecoration(radius: 18, elevated: false),
        clipBehavior: Clip.antiAlias,
        child: Obx(() {
          final hasText = controller.searchQuery.trim().isNotEmpty;

          return TextField(
            key: const Key('search_field'),
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
            style: textTheme.bodyMedium,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Cari pasien berdasarkan nama',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: AppTheme.textTertiary,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 18, right: 8),
                child: Icon(
                  Icons.search_rounded,
                  color: AppTheme.textTertiary,
                  size: 22,
                ),
              ),
              suffixIcon: hasText
                  ? IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                      onPressed: () {
                        controller.clearFilters();
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.only(right: 18),
                      child: Icon(
                        Icons.search_rounded,
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              isDense: true,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final selected = controller.selectedStatusFilter;

      return SizedBox(
        height: 40,
        child: ListView.separated(
          key: const Key('filter_chips_list'),
          scrollDirection: Axis.horizontal,
          itemCount: HomeController.statusFilterOptions.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final option = HomeController.statusFilterOptions[index];
            final isSelected = selected == option.status;

            return GestureDetector(
              onTap: () => controller.onFilterChanged(option.status),
              child: AnimatedContainer(
                duration: AppTheme.motion,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : AppTheme.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                  ),
                  boxShadow:
                      isSelected ? null : AppTheme.softShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (option.status == 'critical')
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    Text(
                      option.label,
                      style: textTheme.labelMedium?.copyWith(
                        color:
                            isSelected ? Colors.white : AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildPatientHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pasien Anda', style: textTheme.titleLarge),
              Text(
                'Pilih pasien untuk melihat detail kesehatan.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppTheme.border),
          ),
          child: Text(
            '${controller.elderlyList.length} pasien',
            style: textTheme.labelMedium?.copyWith(color: AppTheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPatientState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.accentSoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.people_outline_rounded,
              size: 34,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text('Belum ada pasien', style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Tambahkan pasien pertama Anda untuk mulai memantau kesehatan dan jadwal harian.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            key: const Key('empty_add_patient_button'),
            onPressed: () => Get.toNamed(Routes.TAMBAH_LANSIA),
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
            label: const Text('Tambah Pasien'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.surfaceMuted,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 34,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 18),
          Text('Pasien tidak ditemukan', style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Tidak ada pasien yang sesuai dengan pencarian atau filter Anda.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            key: const Key('clear_filter_button'),
            onPressed: controller.clearFilters,
            icon: const Icon(Icons.close_rounded, size: 18),
            label: const Text('Hapus Filter'),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard({
    required BuildContext context,
    required String name,
    required String age,
    required String status,
    required bool isCritical,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final badgeColor = isCritical ? AppTheme.warningSoft : AppTheme.accentSoft;
    final badgeTextColor = isCritical ? AppTheme.warning : AppTheme.primary;
    final avatarBackground = isCritical ? 'f59e0b' : 'BBF246';
    final avatarText = isCritical ? 'fff' : '192126';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          onTap: onTap,
          child: Ink(
            decoration: AppTheme.cardDecoration(
              borderColor: isCritical ? AppTheme.warningSoft : AppTheme.border,
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.surface, width: 3),
                    boxShadow: AppTheme.softShadow,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://ui-avatars.com/api/?name=$name&background=$avatarBackground&color=$avatarText',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person_rounded,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        age,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCritical
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle_outline_rounded,
                            size: 13,
                            color: badgeTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: textTheme.labelMedium?.copyWith(
                              color: badgeTextColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.textTertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
