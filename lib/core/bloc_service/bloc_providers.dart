import 'package:chapainawabganjcity/feature/data_add/presentation/cubit/activity_form_cubit.dart';
import 'package:chapainawabganjcity/feature/login/presentation/presentation/bloc/login_cubit.dart';
import 'package:chapainawabganjcity/feature/profile/presentation/bloc/profile_info_cubit/profile_info_cubit.dart';
import 'package:chapainawabganjcity/feature/signup/presentation/bloc/signup_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/profile/presentation/bloc/profile_update_cubit/profile_update_cubit.dart';

class BlocProviders {
  static List<BlocProvider> getProviders() {
    return [
      BlocProvider<SignupCubit>(create: (context) => SignupCubit(),),
      BlocProvider<LoginCubit>(create: (context) => LoginCubit(),),
      BlocProvider<ActivityFormCubit>(create: (context) => ActivityFormCubit(),),
      BlocProvider<ProfileUpdateCubit>(create: (context) => ProfileUpdateCubit(),),
      BlocProvider<ProfileCubit>(create: (context) => ProfileCubit(),),

    ];
  }
}
