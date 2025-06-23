import 'package:chapainawabganjcity/core/network_service/api_client.dart';
import 'package:chapainawabganjcity/core/network_service/api_constants.dart';
import 'package:chapainawabganjcity/core/shared_prefs_service/shared_pref_keys.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/profile_info_response.dart';
import '../model/profile_update_response.dart';

class ProfileRepository {

  Future<UserProfileResponse> getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(SharedPrefKeys.authToken);

      Response response = await ApiClient.instance.dio.get(
        ApiConstants.profileInfo,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return UserProfileResponse.fromJson(response.data);
      } else {
        print("Failed to fetch profile: ${response.statusCode}");
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      throw Exception('Failed to load user profile');
    }
  }

  Future<ProfileUpdateResponse> uploadProfilePicture({
    required String name,
    required File imageFile,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(SharedPrefKeys.authToken);
      FormData formData = FormData.fromMap({
        'name': name,
        'thumb': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      Response response = await ApiClient.instance.dio.post(
        ApiConstants.updateProfile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ProfileUpdateResponse.fromJson(response.data);
      } else {
        print("Failed to update profile: ${response.statusCode}");
        throw Exception('Error to update');
      }
    } catch (e) {
      print("Error uploading profile picture: $e");
      rethrow;
    }
  }
}
