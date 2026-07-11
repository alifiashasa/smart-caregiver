import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  static const double _sheetOverlap = 34;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headerHeight = size.height * 0.58;

    return Scaffold(
      key: const Key('splash_scaffold'),
      backgroundColor: AppTheme.surface,
      body: Column(
        children: [
          SizedBox(
            height: headerHeight,
            width: double.infinity,
            child: _buildHeader(context),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -_sheetOverlap),
              child: _buildSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppTheme.primary),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: 28,
              right: -40,
              child: _OutlineCircle(size: 128, color: AppTheme.accent),
            ),
            Positioned(
              left: 34,
              bottom: 90,
              child: _OutlineCircle(
                size: 70,
                color: Colors.white.withValues(alpha: 0.28),
              ),
            ),
            Positioned(
              right: 50,
              bottom: 64,
              child: _OutlineCircle(
                size: 44,
                color: AppTheme.accent.withValues(alpha: 0.8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 42, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Caregiver',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppTheme.accent,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Perawatan lansia\nlebih tenang dan\nterpantau.',
                    style: textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                      height: 1.18,
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

  Widget _buildSheet(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 38, 28, 28),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: Column(
        children: [
          const Spacer(),
          Text(
            'Smart Caregiver',
            textAlign: TextAlign.center,
            style: textTheme.displaySmall?.copyWith(
              color: AppTheme.primary,
              fontSize: 34,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Pantau pasien, jadwal, dan catatan kesehatan dalam satu aplikasi.',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: AppTheme.textTertiary),
          ),
          const Spacer(),
          Obx(
            () => ElevatedButton(
              key: const Key('start_button'),
              onPressed: controller.isLoading ? null : controller.start,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.primary,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
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
                          color: AppTheme.primary,
                        ),
                      )
                    : const Text(key: ValueKey('label'), 'Mulai'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineCircle extends StatelessWidget {
  const _OutlineCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.26), width: 2),
      ),
    );
  }
}
