import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  static const double _headerHeight = 300;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: bottomInset),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  _buildHeader(context),
                  Transform.translate(
                    offset: const Offset(0, -34),
                    child: _buildSheet(context, constraints.maxHeight),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              top: 22,
              right: -38,
              child: _OutlineCircle(size: 120, color: AppTheme.accent),
            ),
            Positioned(
              left: 26,
              bottom: 34,
              child: _OutlineCircle(
                size: 62,
                color: Colors.white.withValues(alpha: 0.26),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 36, 28, 0),
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
                  const SizedBox(height: 18),
                  Text(
                    'Masuk untuk menjaga\nperawatan tetap\nterpantau.',
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

  Widget _buildSheet(BuildContext context, double screenHeight) {
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
                  'Login',
                  style: textTheme.headlineSmall?.copyWith(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.REGISTER),
                      child: Text(
                        'Daftar',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _buildEmailField(),
                const SizedBox(height: 14),
                _buildPasswordField(),
                const SizedBox(height: 24),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      onChanged: (value) => controller.email = value,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: const [AutofillHints.email],
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: _fieldDecoration(
        labelText: 'Email',
        hintText: 'contoh@gmail.com',
        prefixIcon: const Icon(Icons.mail_outline_rounded),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextFormField(
        onChanged: (value) => controller.password = value,
        autocorrect: false,
        enableSuggestions: false,
        autofillHints: const [AutofillHints.password],
        textCapitalization: TextCapitalization.none,
        obscureText: controller.isPasswordHidden,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => controller.login(),
        decoration: _fieldDecoration(
          labelText: 'Kata Sandi',
          hintText: 'Masukkan kata sandi',
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            tooltip: controller.isPasswordHidden
                ? 'Tampilkan kata sandi'
                : 'Sembunyikan kata sandi',
            icon: Icon(
              controller.isPasswordHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: controller.togglePasswordVisibility,
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

  Widget _buildLoginButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading ? null : controller.login,
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
              : const Text(key: ValueKey('label'), 'Masuk'),
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
