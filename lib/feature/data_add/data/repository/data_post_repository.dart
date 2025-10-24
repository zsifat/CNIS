import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../core/network_service/api_client.dart';
import '../../../../core/network_service/api_constants.dart';

class DataPostRepository {
  Future<Response> postActivity({
    required String title,
    required String upazila,
    required int catId,
    String? contact,
    File? thumb,
    int? subCategory,
    String? degree,
    String? address,
    String? idLink,
    String? chamber,
    String? price,
    String? bloodGroup,
    String? date,
    String? email,
    String? details,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'upazilla': upazila,
        'cat_id': catId.toString(),
        'contact': contact,
        if (thumb != null)
          'thumb': await MultipartFile.fromFile(
            thumb.path,
            filename: thumb.path.split('/').last,
          ),
        if (subCategory != null) 'sub_category': subCategory.toString(),
        if (degree != null) 'degree': degree,
        if (address != null) 'address': address,
        if (idLink != null) 'id_link': idLink,
        if (chamber != null) 'chamber': chamber,
        if (price != null) 'price': price,
        if (bloodGroup != null) 'blood_group': bloodGroup,
        if (date != null) 'date': date,
        if (email != null) 'email': email,
        if (details != null) 'details': details,
      });

      final response = await ApiClient.instance.post(
        ApiConstants.dataPost,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Response> postNews({
    required String title,
    required String description,
    required int catId,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'cat_id': catId.toString(),
        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      final response = await ApiClient.instance.post(
        ApiConstants.newsPost,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('News post failed');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
