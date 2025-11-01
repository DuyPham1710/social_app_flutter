import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/ui_utils.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/shared/component/button_custom.dart';
import 'package:social_app_fe/shared/component/textFormField_custom.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_event.dart';

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
  bool _isPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    // Reset AuthBloc state when entering login page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<AuthBloc>(context).add(AuthReset());
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            // Chỉ xử lý state từ login flow
            if (state is AuthLoaded && state.flowType == 'login') {
              context.read<MenuBloc>().add(LoadCurrentUserEvent());
              Navigator.pushReplacementNamed(context, '/main');
            } else if (state is AuthError && state.flowType == 'login') {
              final errorMsg = state.errorMessage ?? 'Đăng nhập thất bại';
              UIUtils.showErrorMessage(context, errorMsg);
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
                      Image.asset(
                        'assets/icons/logo.jpg',
                        height: 120.h,
                        width: 120.w,
                      ),

                      SizedBox(height: 40.h),

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

                      TextformfieldCustom(
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

                      TextformfieldCustom(
                        label: 'Password',
                        isPassword: _isPasswordVisible,
                        controller: _passwordController,
                        focusNode: passwordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_fill,
                            size: 22.sp,
                            color: Colors.grey[600],
                          ),
                        ),
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
                          : ButtonCustom(
                              onPressed: () => _onLoginPressed(context),
                              text: "Sign In",
                            ),

                      SizedBox(height: 24.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Do not have an Account? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
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
                                fontSize: 14.sp,
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
