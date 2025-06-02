import 'package:equatable/equatable.dart';

class SignupState extends Equatable{
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState{}
class SignupLoading extends SignupState{}
class SignupSuccess extends SignupState{}
class SignupFailed extends SignupState{}