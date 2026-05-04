import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/ui_utils.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_state.dart';
import 'package:social_app_fe/shared/component/button_custom.dart';
import 'package:social_app_fe/shared/component/textFormField_custom.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  _onForgotPasswordPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(
        context,
      ).add(ResendOtpEvent(email: _emailController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpResendSuccess && state.flowType == 'resend_otp') {
            // Reset state trước khi navigate để tránh state cũ trigger ở OTP page
            BlocProvider.of<AuthBloc>(context).add(AuthReset());
            Navigator.pushNamed(
              context,
              '/otp',
              arguments: {
                'email': _emailController.text.trim(),
                'isForgotPassword': true,
              },
            );
          } else if (state is AuthError && state.flowType == 'resend_otp') {
            final message = state.errorMessage ?? 'Gửi OTP thất bại';
            UIUtils.showErrorMessage(context, message);
            BlocProvider.of<AuthBloc>(context).add(AuthReset());
          }
        },

        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(CupertinoIcons.back, color: Colors.grey[600]),
                    ),

                    SizedBox(height: 50.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Quên mật khẩu",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Text(
                      "Nhập email của bạn để khôi phục tài khoản.",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 50.h),

                    TextformfieldCustom(
                      label: 'Email',
                      isPassword: false,
                      controller: _emailController,
                      focusNode: emailFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 320.h),

                    state is OtpResendLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : ButtonCustom(
                            onPressed: () => _onForgotPasswordPressed(context),
                            text: "Tiếp tục",
                          ),

                    SizedBox(height: 24.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bạn chưa có tài khoản? ",
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
                            "Đăng ký",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
