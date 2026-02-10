import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/core/widgets/input_field.dart';
import 'package:graduation_project_nti/features/login/cubit/cubit.dart';
import 'package:graduation_project_nti/features/login/cubit/states.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightOrange,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  const Text(
                    "Quotely",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your Daily Dose of Inspiration",
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),

                  const SizedBox(height: 40),

                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        InputField(
                          label: "Email",
                          hint: "Enter your email",
                          icon: Icons.mail_outline,
                          controller: emailCtrl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            if (!GetUtils.isEmail(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Password Field
                        InputField(
                          label: "Password",
                          hint: "Enter your password",
                          icon: Icons.lock_outline,
                          controller: passCtrl,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        //Get.toNamed(AppRoutes.forgotPassword);
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Color(0xFFFF7F50)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  //Login Button
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginFailure) {
                        Get.snackbar(
                          "Error",
                          state.message,
                          backgroundColor: Colors.red,
                        );
                      } else if(state is LoginSuccess){
                        Get.snackbar(
                          "Success",
                          "Loged in successfully",
                          backgroundColor: Colors.green,
                        );
                        // if (state.action == AuthAction.login) {
                        //   Get.offAllNamed(AppRoutes.main);
                        // }
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return const CircularProgressIndicator();
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<LoginCubit>().login(
                                emailCtrl.text,
                                passCtrl.text,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: const Color(0x66FF7F50),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                      GestureDetector(
                       // onTap: () => Get.toNamed(AppRoutes.signup),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFFFF7F50),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
