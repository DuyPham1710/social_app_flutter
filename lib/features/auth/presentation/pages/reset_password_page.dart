import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:social_app_fe/shared/helpers/show_dialog_success.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode newPasswordFocusNode = FocusNode();

  final FocusNode confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  void _onSaveSubmitted(BuildContext context, String email, String otp) {
    if (_formKey.currentState!.validate()) {
      final newPassword = newPasswordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      BlocProvider.of<AuthBloc>(context).add(
        ResetPasswordEvent(
          email: email,
          otp: otp,
          newPassword: newPassword,
          confirmNewPassword: confirmPassword,
        ),
      );
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = args['email'] as String;
    final otp = args['otp'] as String;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Chỉ xử lý state từ reset_password flow
          if (state is AuthLoaded && state.flowType == 'reset_password') {
            showDialogSuccess(context, context.l10n.authResetPasswordSuccess);
            //   BlocProvider.of<AuthBloc>(context).add(AuthReset());
          } else if (state is AuthError && state.flowType == 'reset_password') {
            final message =
                state.errorMessage ?? context.l10n.authResetPasswordFailed;
            UIUtils.showErrorMessage(context, message);
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
                          context.l10n.authResetPassword,
                          style: TextStyle(
                            fontSize: 24.rsp(context),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.rsh(context)),

                      Text(
                        context.l10n.authResetPasswordDescription,
                        style: TextStyle(
                          fontSize: 16.rsp(context),
                          color: AppColors.textSecondary,
                        ),
                      ),

                      SizedBox(height: 40.rsh(context)),

                      TextformfieldCustom(
                        label: context.l10n.authNewPassword,
                        isPassword: _isPasswordVisible,
                        controller: newPasswordController,
                        focusNode: newPasswordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.authEnterNewPassword;
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
                            size: 22.rsp(context),
                            color: AppColors.unselectedIcon,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.rsh(context)),

                      TextformfieldCustom(
                        label: context.l10n.authConfirmNewPassword,
                        isPassword: _isConfirmPasswordVisible,
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.authEnterConfirmNewPassword;
                          }
                          return null;
                        },
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isConfirmPasswordVisible
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_fill,
                            size: 22.rsp(context),
                            color: AppColors.unselectedIcon,
                          ),
                        ),
                      ),

                      SizedBox(height: 200.rsh(context)),

                      state is AuthLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                          : ButtonCustom(
                              onPressed: () =>
                                  _onSaveSubmitted(context, email, otp),
                              text: context.l10n.authSave,
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
            ),
          );
        },
      ),
    );
  }
}
