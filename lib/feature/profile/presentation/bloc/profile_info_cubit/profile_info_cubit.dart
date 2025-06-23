import 'package:bloc/bloc.dart';
import 'package:chapainawabganjcity/feature/profile/data/repository/profile_repository.dart';
import 'package:chapainawabganjcity/feature/profile/presentation/bloc/profile_info_cubit/profile_info_state.dart';
import 'package:equatable/equatable.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository = ProfileRepository();

  ProfileCubit() : super(ProfileInitial());

  Future<void> loadUserProfile() async {
    emit(ProfileLoadInProgress());
    try {
      final profile = await repository.getUserInfo();
      emit(ProfileLoadSuccess(profile));
    } catch (e) {
      emit(ProfileLoadFailure(e.toString()));
    }
  }
}