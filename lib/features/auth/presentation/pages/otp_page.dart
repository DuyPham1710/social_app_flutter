import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:pinput/pinput.dart';
import 'package:social_app_fe/core/constants/constants.dart';
import 'package:social_app_fe/core/utils/ui_utils.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_state.dart';
import 'package:social_app_fe/shared/component/button_custom.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otpCode = '';
  int _secondsRemaining = OTP_DURATION; // 1 phút
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  final defaultPinTheme = PinTheme(
    width: 50.w,
    height: 50.h,
    textStyle: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: Colors.grey),
    ),
  );

  void _verifyOtp(BuildContext context, String email) {
    if (otpCode.length == 6) {
      BlocProvider.of<AuthBloc>(
        context,
      ).add(VerifyOtpEvent(email: email, otp: otpCode));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
    }
  }

  void _resendOtp(BuildContext context, String email) {
    BlocProvider.of<AuthBloc>(context).add(ResendOtpEvent(email: email));
  }

  void _startCountdown() {
    _timer?.cancel(); // hủy timer cũ nếu có
    _secondsRemaining = OTP_DURATION;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = args['email'] as String;
    final isForgotPassword = args['isForgotPassword'] as bool? ?? false;

    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoaded && isForgotPassword) {
              print("check email $email and check otp $otpCode");
              Navigator.pushNamed(
                context,
                '/reset-password',
                arguments: {'email': email, 'otp': otpCode},
              );
            } else if (state is AuthLoaded && !isForgotPassword) {
              BlocProvider.of<AuthBloc>(context).add(AuthReset());
              Navigator.pushReplacementNamed(
                context,
                '/personal-info',
                arguments: {
                  'id': args['id'], // lấy id đã truyền từ RegisterPage
                },
              );
            } else if (state is OtpResendSuccess) {
              UIUtils.showSuccessMessage(context, state.message);
              _startCountdown();
            } else if (state is AuthError) {
              final message = state.errorMessage ?? 'xác thực thất bại';
              UIUtils.showErrorMessage(context, message);
              BlocProvider.of<AuthBloc>(
                context,
              ).add(AuthReset()); // reset sau khi show lỗi
            }
          },

          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                        "Otp sent",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "Enter the OTP sent to $email",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 40.h),

                    Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.black, width: 2.w),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          otpCode = value;
                        });
                      },
                    ),

                    SizedBox(height: 30.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        GestureDetector(
                          onTap: _secondsRemaining > 0
                              ? null
                              : () => _resendOtp(context, email),
                          child: Text(
                            state is OtpResendLoading
                                ? 'Resending...'
                                : _secondsRemaining > 0
                                ? "Resend in $_secondsRemaining s"
                                : "Resend Code",
                            style: TextStyle(
                              color: _secondsRemaining > 0
                                  ? AppColors.primary
                                  : Colors.red,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 280.h),

                    state is AuthLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : ButtonCustom(
                            onPressed: () => _verifyOtp(context, email),
                            text: "Verify",
                          ),

                    SizedBox(height: 24.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an Account? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            "Sign in",
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
            );
          },
        ),
      ),
    );
  }
}
