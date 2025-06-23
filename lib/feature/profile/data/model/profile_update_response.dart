class ProfileUpdateResponse {
  final bool success;
  final String message;
  final ProfileData? data;

  ProfileUpdateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String roleId;
  final String? thumb;
  final String? twoFactorSecret;
  final String? twoFactorRecoveryCodes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.roleId,
    required this.thumb,
    required this.twoFactorSecret,
    required this.twoFactorRecoveryCodes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      roleId: json['role_id'] ?? '',
      thumb: json['thumb'],
      twoFactorSecret: json['two_factor_secret'],
      twoFactorRecoveryCodes: json['two_factor_recovery_codes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
