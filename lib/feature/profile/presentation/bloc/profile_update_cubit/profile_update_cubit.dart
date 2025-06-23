import 'dart:io';
import 'package:chapainawabganjcity/feature/profile/data/repository/profile_repository.dart';
import 'package:chapainawabganjcity/feature/profile/presentation/bloc/profile_update_cubit/profile_update_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProfileUpdateCubit extends Cubit<ProfileUpdateState> {
  final ProfileRepository repository = ProfileRepository();

  ProfileUpdateCubit() : super(ProfileUpdateInitial());

  Future<void> uploadProfilePicture({
    required String name,
    required File imageFile,
  }) async {
    emit(ProfileUploading());
    try {
      final response = await repository.uploadProfilePicture(
        name: name,
        imageFile: imageFile,
      );
      emit(ProfileUploadSuccess(response));
    } catch (e) {
      emit(ProfileUploadFailure(e.toString()));
    }
  }
}
