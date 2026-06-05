import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:pinput/pinput.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/utils/ui_utils.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_state.dart';
import 'package:social_app_fe/features/auth/presentation/widgets/auth_responsive_wrapper.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/component/button_custom.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otpCode = '';
  int _secondsRemaining = int.parse(
    dotenv.env['OTP_DURATION'] ?? '60',
  ); // 1 phút
  Timer? _timer;
  String? _email; // Lưu email vào biến local
  bool? _isForgotPassword;

  @override
  void initState() {
    super.initState();
    _startCountdown();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthReset());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lấy args một lần và lưu vào biến local
    if (_email == null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _email = args['email'] as String;
      _isForgotPassword = args['isForgotPassword'] as bool? ?? false;
    }
  }

  PinTheme _defaultPinTheme(BuildContext context) => PinTheme(
    width: 50.rs(context),
    height: 50.rsh(context),
    textStyle: TextStyle(
      fontSize: 20.rsp(context),
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.rsr(context)),
      border: Border.all(color: AppColors.divider),
    ),
  );

  void _verifyOtp(BuildContext context) {
    if (otpCode.length == 6) {
      BlocProvider.of<AuthBloc>(
        context,
      ).add(VerifyOtpEvent(email: _email!, otp: otpCode));
    } else {
      showErrorSnackBar(context, context.l10n.authInvalidOtp);
    }
  }

  void _resendOtp(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(ResendOtpEvent(email: _email!));
  }

  void _startCountdown() {
    _timer?.cancel(); // hủy timer cũ nếu có
    _secondsRemaining = int.parse(dotenv.env['OTP_DURATION'] ?? '60');
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
    final defaultPinTheme = _defaultPinTheme(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Chỉ xử lý state từ verify_otp flow
          if (state is AuthLoaded && state.flowType == 'verify_otp') {
            context.read<AuthBloc>().add(AuthReset());

            if (_isForgotPassword ?? false) {
              Navigator.pushNamed(
                context,
                '/reset-password',
                arguments: {'email': _email, 'otp': otpCode},
              );
            } else {
              final args =
                  ModalRoute.of(context)!.settings.arguments
                      as Map<String, dynamic>;
              Navigator.pushReplacementNamed(
                context,
                '/personal-info',
                arguments: {'id': args['id']},
              );
            }
          } else if (state is OtpResendSuccess &&
              state.flowType == 'resend_otp') {
            // Chỉ hiện message khi user thực sự resend OTP từ OTP page
            showSuccessSnackBar(context, state.message);
            _startCountdown();
          } else if (state is AuthError && state.flowType == 'verify_otp') {
            final message = state.errorMessage ?? context.l10n.authVerifyOtpFailed;
            UIUtils.showErrorMessage(context, message);
            BlocProvider.of<AuthBloc>(
              context,
            ).add(AuthReset()); // reset sau khi show lỗi
          }
        },

        builder: (context, state) {
          return AuthResponsiveWrapper(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.rsh(context)),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        CupertinoIcons.back,
                        color: AppColors.unselectedIcon,
                      ),
                    ),

                    SizedBox(height: 50.rsh(context)),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.l10n.authOtpTitle,
                        style: TextStyle(
                          fontSize: 24.rsp(context),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(height: 10.rsh(context)),

                    Text(
                      context.l10n.authOtpSentTo(_email ?? ''),
                      style: TextStyle(
                        fontSize: 16.rsp(context),
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 40.rsh(context)),

                    Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.rsr(context)),
                          border: Border.all(
                            color: AppColors.textPrimary,
                            width: 2.rs(context),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          otpCode = value;
                        });
                      },
                    ),

                    SizedBox(height: 30.rsh(context)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.authDidNotReceiveCode,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14.rsp(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        GestureDetector(
                          onTap: _secondsRemaining > 0
                              ? null
                              : () => _resendOtp(context),
                          child: Text(
                            state is OtpResendLoading
                                ? context.l10n.authResendingOtp
                                : _secondsRemaining > 0
                                ? context.l10n.authResendInSeconds(
                                    _secondsRemaining,
                                  )
                                : context.l10n.authResendCode,
                            style: TextStyle(
                              color: _secondsRemaining > 0
                                  ? AppColors.primary
                                  : Colors.red,
                              fontSize: 14.rsp(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 280.rsh(context)),

                    state is AuthLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : ButtonCustom(
                            onPressed: () => _verifyOtp(context),
                            text: context.l10n.authVerify,
                          ),

                      SizedBox(height: 24.rsh(context)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.l10n.authHasAccount,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14.rsp(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              context.l10n.authLogin,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14.rsp(context),
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
