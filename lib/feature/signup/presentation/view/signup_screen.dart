import 'package:chapainawabganjcity/feature/login/presentation/presentation/bloc/login_cubit.dart';
import 'package:chapainawabganjcity/feature/signup/presentation/bloc/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../bloc/signup_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _phoneNo = '';
  String _password = '';
  bool _obscurePassword = true;

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
                // Brand Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.asset(
                    'assets/images/cnis_updated_logo.jpg',
                    height: 140,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'নতুন অ্যাকাউন্ট তৈরি করুন',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // Username
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.green.shade800,
                    ),
                    filled: false,
                    hintText: 'আপনার নাম',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                        )),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.green.shade800,
                          width: 1,
                        )),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'নাম খালি রাখা যাবে না';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value!,
                ),
                const SizedBox(height: 15),
                // Email
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone, color: Colors.green.shade800),
                      filled: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          )),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.green.shade800,
                            width: 1,
                          )),
                      hintText: 'ফোন নম্বর দিন'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'সঠিক ফোন নম্বর দিন';
                    }
                    final phoneRegex = RegExp(r'^(?:\+?88)?01[3-9]\d{8}$');
                    if (!phoneRegex.hasMatch(value)) {
                      return 'সঠিক ফোন নম্বর লিখুন';
                    }
                    return null;
                  },
                  onSaved: (value) => _phoneNo = value!,
                ),
                const SizedBox(height: 15),

                // Password
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'পাসওয়ার্ড লিখুন',
                    filled: false,
                    prefixIcon: Icon(Icons.password, color: Colors.green.shade800),
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
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.green.shade800,
                          width: 1,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:  BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        )),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        )),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'পাসওয়ার্ড অবশ্যই কমপক্ষে ৮ অক্ষরের হতে হবে';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 25),

                // Sign Up Button
                BlocConsumer<SignupCubit, SignupState>(
                  listener: (context, state) {
                    if (state is SignupSuccess) {
                      context.read<LoginCubit>().login(mobile: _phoneNo, password: _password);
                    } else if (state is SignupFailed) {
                      Get.snackbar(
                        'Signup Failed',
                        'Something went wrong',
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
                          context
                              .read<SignupCubit>()
                              .signUP(userName: _username, mobile: _phoneNo, password: _password);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                            color: Colors.green.shade800, borderRadius: BorderRadius.circular(16)),
                        child: Center(
                            child: state is SignupLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'রেজিস্ট্রেশন করুন',
                                    style:
                                        TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                  )),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
