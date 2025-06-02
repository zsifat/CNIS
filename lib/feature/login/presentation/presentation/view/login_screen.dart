import 'package:chapainawabganjcity/feature/login/presentation/presentation/bloc/login_cubit.dart';
import 'package:chapainawabganjcity/feature/login/presentation/presentation/bloc/login_state.dart';
import 'package:chapainawabganjcity/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../signup/presentation/view/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.asset(
                    'assets/images/cnis_updated_logo.jpg',
                    height: 140,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'আপনার একাউন্টে প্রবেশ করুন',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // Email
                TextFormField(
                  decoration: InputDecoration(
                    filled: false,
                    prefixIcon: Icon(Icons.email, color: Colors.green.shade800),
                    hintText: 'আপনার ইমেইল',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.green.shade800,
                        width: 1,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'সঠিক ইমেইল দিন';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'সঠিক ইমেইল লিখুন';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 15),

                // Password
                TextFormField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: false,
                    hintText: 'পাসওয়ার্ড লিখুন',
                    prefixIcon: Icon(Icons.lock, color: Colors.green.shade800),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.green.shade800,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.green.shade800,
                        width: 1,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'পাসওয়ার্ড অবশ্যই কমপক্ষে ৮ অক্ষরের হতে হবে';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 25),

                // Login Button
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      Get.to(const MainScreen());
                    }else if(state is LoginFailed){
                      Get.snackbar(
                        'Login Failed',
                        'Invalid Credentials',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(10),
                        duration: const Duration(seconds: 3),
                      );
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<LoginCubit>().login(email: _email, password: _password);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:  Center(
                          child: state is LoginLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'প্রবেশ করুন',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Register Link Button
                TextButton(
                  onPressed: () {
                    Get.to(() => const SignUpScreen());
                  },
                  child: Text(
                    'রেজিস্টার করুন',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
