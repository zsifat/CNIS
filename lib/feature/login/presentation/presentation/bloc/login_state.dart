import 'package:equatable/equatable.dart';

class LoginState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState{}
class LoginLoading extends LoginState{}
class LoginSuccess extends LoginState{}
class LoginFailed extends LoginState{}