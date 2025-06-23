class UserProfileResponse {
  final bool success;
  final UserProfileData data;

  UserProfileResponse({
    required this.success,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'],
      data: UserProfileData.fromJson(json['data']),
    );
  }
}

class UserProfileData {
  final String name;
  final String thumb;

  UserProfileData({
    required this.name,
    required this.thumb,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      name: json['name'],
      thumb: 'https://cnis.smartbizz.xyz/storage/app/${json['thumb']}',
    );
  }
}