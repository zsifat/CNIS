import 'package:chapainawabganjcity/core/shared_prefs_service/shared_pref_keys.dart';
import 'package:chapainawabganjcity/feature/login/presentation/presentation/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../signup/data/repository/auth_repository.dart';

class LoginCubit extends Cubit<LoginState>{
  LoginCubit():super(LoginInitial());
  final _authRepository = AuthRepository();

  Future<void> login({required String email, required String password}) async{
    emit(LoginLoading());
    try{
      final response =await _authRepository.login(email: email, password: password);
      print(response.data);
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(SharedPrefKeys.isLogin, true);
      emit(LoginSuccess());
    }catch(e){
      emit(LoginFailed());
      throw Exception(e);
    }
  }
}