import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/ui_utils.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_state.dart';
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

    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoaded) {
              showDialogSuccess(context, "Reset Password");
              //   BlocProvider.of<AuthBloc>(context).add(AuthReset());
            } else if (state is AuthError) {
              final message = state.errorMessage ?? 'Reset password thất bại';
              UIUtils.showErrorMessage(context, message);
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
                        child: Icon(
                          CupertinoIcons.back,
                          color: Colors.grey[600],
                        ),
                      ),

                      SizedBox(height: 50.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pick a new password",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Text(
                        "Help us keep your account secure by choosing a strong password.",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),

                      SizedBox(height: 40.h),

                      TextformfieldCustom(
                        label: "New Password",
                        isPassword: _isPasswordVisible,
                        controller: newPasswordController,
                        focusNode: newPasswordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your New Password';
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

                      SizedBox(height: 20.h),

                      TextformfieldCustom(
                        label: "Confirm New Password",
                        isPassword: _isConfirmPasswordVisible,
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Confirm New Password';
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
                            size: 22.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),

                      SizedBox(height: 200.h),

                      state is AuthLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                          : ButtonCustom(
                              onPressed: () =>
                                  _onSaveSubmitted(context, email, otp),
                              text: "Save",
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
              ),
            );
          },
        ),
      ),
    );
  }
}
