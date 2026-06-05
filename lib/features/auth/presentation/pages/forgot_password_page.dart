import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/utils/ui_utils.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_state.dart';
import 'package:social_app_fe/features/auth/presentation/widgets/auth_responsive_wrapper.dart';
import 'package:social_app_fe/l10n/l10n.dart';
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
      backgroundColor: AppColors.background,
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
            final message = state.errorMessage ?? context.l10n.authSendOtpFailed;
            UIUtils.showErrorMessage(context, message);
            BlocProvider.of<AuthBloc>(context).add(AuthReset());
          }
        },

        builder: (context, state) {
          return AuthResponsiveWrapper(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
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
                          context.l10n.authForgotPassword,
                          style: TextStyle(
                            fontSize: 24.rsp(context),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.rsh(context)),

                      Text(
                        context.l10n.authForgotPasswordDescription,
                        style: TextStyle(
                          fontSize: 16.rsp(context),
                          color: AppColors.textSecondary,
                        ),
                      ),

                      SizedBox(height: 50.rsh(context)),

                      TextformfieldCustom(
                        label: context.l10n.authEmail,
                        isPassword: false,
                        controller: _emailController,
                        focusNode: emailFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.authEnterEmail;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 320.rsh(context)),

                      state is OtpResendLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                          : ButtonCustom(
                              onPressed: () => _onForgotPasswordPressed(context),
                              text: context.l10n.authContinue,
                            ),

                      SizedBox(height: 24.rsh(context)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.l10n.authNoAccount,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14.rsp(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                              context.l10n.authRegister,
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
            ),
          );
        },
      ),
    );
  }
}
