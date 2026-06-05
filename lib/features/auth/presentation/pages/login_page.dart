import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/services/fcm_service.dart';
import 'package:social_app_fe/core/utils/ui_utils.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_state.dart';
import 'package:social_app_fe/features/auth/presentation/widgets/auth_responsive_wrapper.dart';
import 'package:social_app_fe/l10n/l10n.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          // Chỉ xử lý state từ login flow
          if (state is AuthLoaded && state.flowType == 'login') {
            context.read<MenuBloc>().add(LoadCurrentUserEvent());

            // Update FCM token after successful login
            await FcmService().updateFcmToken();
            Navigator.pushReplacementNamed(context, '/main');
          } else if (state is AuthError && state.flowType == 'login') {
            final errorMsg = state.errorMessage ?? context.l10n.authLoginFailed;
            UIUtils.showErrorMessage(context, errorMsg);
          }
        },

        builder: (context, state) {
          return AuthResponsiveWrapper(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40.rsh(context)),

                      // Logo
                      Image.asset(
                        s1<AppPreferences>().isDarkMode
                            ? 'assets/icons/dark_logo.png'
                            : 'assets/icons/logo.jpg',
                        height: 120.rsh(context),
                        width: 120.rs(context),
                      ),

                      SizedBox(height: 40.rsh(context)),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          context.l10n.authLogin,
                          style: TextStyle(
                            fontSize: 24.rsp(context),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.rsh(context)),

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

                      SizedBox(height: 14.rsh(context)),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: Text(
                            context.l10n.authForgotPasswordQuestion,
                            style: TextStyle(
                              fontSize: 14.rsp(context),
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: AppColors.divider,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.rsh(context),
                            ),
                            child: Text(
                              context.l10n.authOr,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: AppColors.divider,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30.rsh(context)),

                      Container(
                        width: double.infinity,
                        height: 60.rsh(context),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12.rsr(context)),
                          border: Border.all(color: AppColors.divider),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/google.png',
                              height: 24.rsh(context),
                              width: 24.rs(context),
                            ),
                            SizedBox(width: 12.rs(context)),
                            Text(
                              context.l10n.authLoginWithGoogle,
                              style: TextStyle(
                                fontSize: 16.rsp(context),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 60.rsh(context)),

                      state is AuthLoading
                          ? CircularProgressIndicator(color: AppColors.primary)
                          : ButtonCustom(
                              onPressed: () => _onLoginPressed(context),
                              text: context.l10n.authLogin,
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

                      SizedBox(height: 20.rsh(context)),
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
