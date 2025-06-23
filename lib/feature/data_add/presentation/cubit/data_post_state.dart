import 'package:equatable/equatable.dart';

abstract class ActivityFormState extends Equatable {
  const ActivityFormState();

  @override
  List<Object?> get props => [];
}

class ActivityFormInitial extends ActivityFormState {}

class ActivityFormLoading extends ActivityFormState {}

class ActivityFormSuccess extends ActivityFormState {}

class ActivityFormFailure extends ActivityFormState {
  final String error;

  const ActivityFormFailure(this.error);

  @override
  List<Object?> get props => [error];
}
