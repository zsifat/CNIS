import 'package:dio/src/response.dart';

import '../../../../core/network_service/api_client.dart';
import '../../../../core/network_service/api_constants.dart';
import '../../presentation/bloc/signup_state.dart';

class AuthRepository{
  Future<Response> signUP({required String userName, required String email, required String password}) async{
    try{
      final data ={
        'username':userName,
        'email':email,
        'password':password
      };
      final response = await ApiClient.instance.post(ApiConstants.signUpUrl,data: data);
      if(response.statusCode==200){
        return response;
      }else{
        throw Exception('Something Went Wrong');
      }
    }catch(e){
      throw Exception(e);
    }

  }

  Future<Response> login({required String email, required String password}) async{
    try{
      final data ={
        'email':email,
        'password':password
      };
      final response = await ApiClient.instance.post(ApiConstants.loginUrl,data: data);
      if(response.statusCode==200){
        return response;
      }else{
        throw Exception('Something Went Wrong');
      }
    }catch(e){
      throw Exception(e);
    }

  }
}
