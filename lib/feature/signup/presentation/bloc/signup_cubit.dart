import 'package:chapainawabganjcity/core/network_service/api_client.dart';
import 'package:chapainawabganjcity/core/network_service/api_constants.dart';
import 'package:chapainawabganjcity/feature/signup/data/repository/auth_repository.dart';
import 'package:chapainawabganjcity/feature/signup/presentation/bloc/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/shared_prefs_service/shared_pref_keys.dart';

class SignupCubit extends Cubit<SignupState>{
  SignupCubit():super(SignupInitial());
  final _authRepository = AuthRepository();

  Future<void> signUP({required String userName, required String mobile, required String password}) async{
    emit(SignupLoading());
    try{
      final response =await _authRepository.signUP(userName: userName, mobile: mobile, password: password);
      final prefs = await SharedPreferences.getInstance();
      if(response.data['message']=='User registered successfully.'){
        prefs.setString(SharedPrefKeys.userName, userName);
        emit(SignupSuccess());
      }else{
        emit(SignupFailed());
      }
    }catch(e){
      emit(SignupFailed());
      throw Exception(e);
    }
  }
}