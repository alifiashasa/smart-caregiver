class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.isEmailVerified,
    required this.hasPassword,
    required this.createdAt,
    this.phone,
    this.avatarUrl,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isEmailVerified: json['is_email_verified'] == true,
      hasPassword: json['has_password'] != false,
      lastLoginAt: _readDateTime(json['last_login_at']),
      createdAt:
          _readDateTime(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String? avatarUrl;
  final bool isEmailVerified;
  final bool hasPassword;
  final DateTime? lastLoginAt;
  final DateTime createdAt;

  String get displayName => fullName.isNotEmpty ? fullName : email;

  static DateTime? _readDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toLocal();
  }
}
