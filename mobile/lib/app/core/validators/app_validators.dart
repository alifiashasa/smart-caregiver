class AppValidators {
  const AppValidators._();

  static String? requiredText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName harus diisi';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredText(value, 'Email');
    if (requiredError != null) return requiredError;

    final email = value!.trim();
    final isValid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    if (!isValid) return 'Format email tidak valid';
    return null;
  }

  static String? minLength(String? value, String fieldName, int minLength) {
    final requiredError = requiredText(value, fieldName);
    if (requiredError != null) return requiredError;

    if (value!.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }
    return null;
  }

  static String? positiveInt(String? value, String fieldName) {
    final requiredError = requiredText(value, fieldName);
    if (requiredError != null) return requiredError;

    final parsed = int.tryParse(value!.trim());
    if (parsed == null) return '$fieldName harus berupa angka';
    if (parsed <= 0) return '$fieldName harus lebih dari 0';
    return null;
  }
}
