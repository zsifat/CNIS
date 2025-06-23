import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/data_post_repository.dart';
import 'data_post_state.dart';

class ActivityFormCubit extends Cubit<ActivityFormState> {
  final DataPostRepository repository = DataPostRepository();

  ActivityFormCubit() : super(ActivityFormInitial());

  Future<void> submitActivityForm({
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
    emit(ActivityFormLoading());

    try {
      final response = await repository.postActivity(
        title: title,
        upazila: upazila,
        catId: catId,
        contact: contact,
        thumb: thumb,
        subCategory: subCategory,
        degree: degree,
        address: address,
        idLink: idLink,
        chamber: chamber,
        price: price,
        bloodGroup: bloodGroup,
        date: date,
        email: email,
        details: details,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ActivityFormSuccess());
      } else {
        emit(ActivityFormFailure("Failed: ${response.statusMessage}"));
      }
    } catch (e) {
      emit(ActivityFormFailure(e.toString()));
    }
  }
}
