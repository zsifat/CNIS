import 'package:equatable/equatable.dart';

import '../../../data/model/profile_update_response.dart';

abstract class ProfileUpdateState extends Equatable {
  const ProfileUpdateState();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateInitial extends ProfileUpdateState {}

class ProfileUploading extends ProfileUpdateState {}

class ProfileUploadSuccess extends ProfileUpdateState {
  final ProfileUpdateResponse response;

  const ProfileUploadSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ProfileUploadFailure extends ProfileUpdateState {
  final String message;

  const ProfileUploadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
