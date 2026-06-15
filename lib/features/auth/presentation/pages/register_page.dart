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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode emailFocusNode = FocusNode();

  final FocusNode usernameFocusNode = FocusNode();

  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    // Reset AuthBloc state when entering register page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<AuthBloc>(context).add(AuthReset());
    });
  }

  final FocusNode passwordFocusNode = FocusNode();

  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    emailFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onRegisterPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        RegisterEvent(
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Chỉ xử lý state từ register flow
          if (state is AuthLoaded && state.flowType == 'register') {
            Navigator.pushNamed(
              context,
              '/otp',
              arguments: {
                'email': state.user!.email!.trim(),
                'id': state.user!.userId,
              },
            );
          } else if (state is AuthError && state.flowType == 'register') {
            final message = state.errorMessage ?? context.l10n.authRegisterFailed;
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
                        onTap: () => Navigator.popUntil(
                          context,
                          ModalRoute.withName('/login'),
                        ),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.only(right: 24, bottom: 24),
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.unselectedIcon,
                          ),
                        ),
                      ),

                      SizedBox(height: 50.rsh(context)),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          context.l10n.authRegister,
                          style: TextStyle(
                            fontSize: 24.rsp(context),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
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

                      SizedBox(height: 20.rsh(context)),

                      TextformfieldCustom(
                        label: context.l10n.authUsername,
                        isPassword: false,
                        controller: _usernameController,
                        focusNode: usernameFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.authEnterUsername;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20.rsh(context)),

                      TextformfieldCustom(
                        label: context.l10n.authPassword,
                        isPassword: _isPasswordVisible,
                        controller: _passwordController,
                        focusNode: passwordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.authEnterPassword;
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
                        label: context.l10n.authConfirmPassword,
                        isPassword: _isConfirmPasswordVisible,
                        controller: _confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.authEnterConfirmPassword;
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

                      SizedBox(height: 100.rsh(context)),

                      state is AuthLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                          : ButtonCustom(
                              onPressed: () => _onRegisterPressed(context),
                              text: context.l10n.authRegister,
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
