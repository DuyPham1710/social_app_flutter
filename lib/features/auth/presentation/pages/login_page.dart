import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<AuthBloc>(context).add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  Widget _buildTextFormField({
    required String label,
    required bool isPassword,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const TextStyle(color: AppColors.primary);
          }
          return const TextStyle(color: Colors.grey); // khi không focus
        }),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(width: 1.w, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(width: 2.w, color: AppColors.primary),
        ),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoaded) {
              Navigator.pushReplacementNamed(
                context,
                '/home',
                arguments: state.user,
              );
            } else if (state is AuthError) {
              final errorMsg = state.error?.message ?? 'Login failed';
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(errorMsg)));
            }
          },

          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),

                      // Logo
                      Container(
                        height: 100.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 60.0,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 50.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      _buildTextFormField(
                        label: 'Email',
                        isPassword: false,
                        controller: _emailController,
                        focusNode: emailFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20.h),

                      _buildTextFormField(
                        label: 'Password',
                        isPassword: true,
                        controller: _passwordController,
                        focusNode: passwordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 14.h),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(thickness: 1, color: Colors.grey),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.h),
                            child: Text(
                              "or",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(thickness: 1, color: Colors.grey),
                          ),
                        ],
                      ),

                      SizedBox(height: 30.h),

                      Container(
                        width: double.infinity,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/google.png',
                              height: 24.h,
                              width: 24.w,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Sign in with Google",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 60.h),

                      state is AuthLoading
                          ? CircularProgressIndicator(color: AppColors.primary)
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  backgroundColor: AppColors.primary,
                                ),

                                onPressed: () => _onLoginPressed(context),

                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                      SizedBox(height: 24.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Do not have an Account? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
