import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  static const double _headerHeight = 290;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Obx(() {
        final isOtpStep = controller.showOtpField;

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: bottomInset),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    _buildHeader(context, isOtpStep: isOtpStep),
                    Transform.translate(
                      offset: const Offset(0, -34),
                      child: isOtpStep
                          ? _buildOtpSheet(context, constraints.maxHeight)
                          : _buildRegisterSheet(context, constraints.maxHeight),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, {required bool isOtpStep}) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: _headerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(color: AppTheme.primary),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: -36,
              child: _OutlineCircle(size: 112, color: AppTheme.accent),
            ),
            Positioned(
              left: 30,
              bottom: 28,
              child: _OutlineCircle(
                size: 58,
                color: Colors.white.withValues(alpha: 0.28),
              ),
            ),
            Positioned(
              top: 8,
              left: 12,
              child: IconButton(
                tooltip: 'Kembali',
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 62, 28, 0),
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
                  const SizedBox(height: 16),
                  Text(
                    isOtpStep
                        ? 'Verifikasi akun\ncaregiver Anda.'
                        : 'Buat akun untuk\nmemulai perawatan.',
                    style: textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                      height: 1.2,
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

  Widget _buildRegisterSheet(BuildContext context, double screenHeight) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: screenHeight - _headerHeight + 34),
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: AutofillGroup(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Daftar',
                  style: textTheme.headlineSmall?.copyWith(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        'Masuk',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                TextFormField(
                  onChanged: (value) => controller.name = value,
                  autofillHints: const [AutofillHints.name],
                  textInputAction: TextInputAction.next,
                  decoration: _fieldDecoration(
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkap',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  onChanged: (value) => controller.email = value,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  decoration: _fieldDecoration(
                    labelText: 'Email',
                    hintText: 'contoh@gmail.com',
                    prefixIcon: const Icon(Icons.mail_outline_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                Obx(
                  () => TextFormField(
                    onChanged: (value) => controller.password = value,
                    obscureText: controller.obscurePassword,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration(
                      labelText: 'Kata Sandi',
                      hintText: 'Minimal 6 karakter',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        tooltip: controller.obscurePassword
                            ? 'Tampilkan kata sandi'
                            : 'Sembunyikan kata sandi',
                        icon: Icon(
                          controller.obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Obx(
                  () => TextFormField(
                    onChanged: (value) => controller.confirmPassword = value,
                    obscureText: controller.obscureConfirmPassword,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => controller.register(),
                    decoration: _fieldDecoration(
                      labelText: 'Konfirmasi Kata Sandi',
                      hintText: 'Ulangi kata sandi',
                      prefixIcon: const Icon(Icons.lock_reset_rounded),
                      suffixIcon: IconButton(
                        tooltip: controller.obscureConfirmPassword
                            ? 'Tampilkan kata sandi'
                            : 'Sembunyikan kata sandi',
                        icon: Icon(
                          controller.obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildActionButton(
                  label: 'Daftar',
                  onPressed: controller.register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpSheet(BuildContext context, double screenHeight) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: screenHeight - _headerHeight + 34),
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Verifikasi Email',
                style: textTheme.headlineSmall?.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan kode OTP yang dikirim ke ${controller.registeredEmail}.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
              const SizedBox(height: 28),
              TextFormField(
                onChanged: (value) => controller.otp = value,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                maxLength: 6,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(letterSpacing: 6),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => controller.verifyOtp(),
                decoration: _fieldDecoration(
                  labelText: 'Kode OTP',
                  hintText: '000000',
                  prefixIcon: const Icon(Icons.pin_outlined),
                ).copyWith(counterText: ''),
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                label: 'Verifikasi',
                onPressed: controller.verifyOtp,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => controller.showOtpField = false,
                child: const Text('Gunakan email lain'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String labelText,
    required String hintText,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    return AppTheme.inputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
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
        borderSide: const BorderSide(color: AppTheme.primary, width: 1.3),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading ? null : onPressed,
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
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primary,
                  ),
                )
              : Text(key: const ValueKey('label'), label),
        ),
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
