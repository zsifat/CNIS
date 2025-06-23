import 'package:chapainawabganjcity/feature/data_add/presentation/cubit/activity_form_cubit.dart';
import 'package:chapainawabganjcity/feature/login/presentation/presentation/bloc/login_cubit.dart';
import 'package:chapainawabganjcity/feature/signup/presentation/bloc/signup_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProviders {
  static List<BlocProvider> getProviders() {
    return [
      BlocProvider<SignupCubit>(create: (context) => SignupCubit(),),
      BlocProvider<LoginCubit>(create: (context) => LoginCubit(),),
      BlocProvider<ActivityFormCubit>(create: (context) => ActivityFormCubit(),)
    ];
  }
}