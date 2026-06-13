import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Obx(() {
            if (controller.showOtpField) {
              return _buildOtpStep();
            }
            return _buildRegisterStep();
          }),
        ),
      ),
    );
  }

  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        const Icon(Icons.email_outlined, size: 64, color: Color(0xFFBBF246)),
        const SizedBox(height: 24),
        const Text(
          'Verifikasi Email',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Kode OTP telah dikirim ke\n${controller.registeredEmail}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4C4546),
          ),
        ),
        const SizedBox(height: 40),
        _buildLabel('Kode OTP'),
        _buildTextField(
          hint: '000000',
          keyboardType: TextInputType.number,
          maxLength: 6,
          onChanged: (val) => controller.otp = val,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: controller.isLoading ? null : controller.verifyOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFBBF246),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            elevation: 0,
          ),
          child: controller.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : const Text(
                  'Verifikasi',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => controller.showOtpField = false,
          child: const Text(
            'Gunakan email lain',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              color: Color(0xFF4C4546),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildRegisterStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),

        // Logo & Title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 48),
            const SizedBox(width: 8),
            const Text(
              'CareTrack',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        const Text(
          'Buat Akun Caregiver',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Daftar untuk mulai memantau pasien Anda',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4C4546),
          ),
        ),
        const SizedBox(height: 40),

        // Full Name Field
        _buildLabel('Nama Lengkap'),
        _buildTextField(
          hint: 'Masukkan nama lengkap',
          onChanged: (val) => controller.name = val,
        ),
        const SizedBox(height: 20),

        // Email Field
        _buildLabel('Email'),
        _buildTextField(
          hint: 'contoh@gmail.com',
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) => controller.email = val,
        ),
        const SizedBox(height: 20),

        // Password Field
        _buildLabel('Kata Sandi'),
        Obx(
          () => _buildTextField(
            hint: 'Minimal 8 karakter',
            obscureText: controller.obscurePassword,
            onChanged: (val) => controller.password = val,
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: const Color(0xFF4C4546),
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Confirm Password Field
        _buildLabel('Konfirmasi Kata Sandi'),
        Obx(
          () => _buildTextField(
            hint: 'Ulangi kata sandi',
            obscureText: controller.obscureConfirmPassword,
            onChanged: (val) => controller.confirmPassword = val,
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: const Color(0xFF4C4546),
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Register Button
        ElevatedButton(
          onPressed: controller.isLoading ? null : controller.register,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFBBF246),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            elevation: 0,
          ),
          child: controller.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : const Text(
                  'Daftar Sekarang',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        const SizedBox(height: 24),

        // Login Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sudah punya akun? ',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                color: Color(0xFF4C4546),
              ),
            ),
            GestureDetector(
              onTap: () => Get.back(),
              child: const Text(
                'Masuk',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1B1B1B),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    int? maxLength,
  }) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      style: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF4C4546)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        suffixIcon: suffixIcon,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFA5F482)),
        ),
      ),
    );
  }
}
