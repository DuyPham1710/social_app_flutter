import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
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
      Navigator.pushNamed(
        context,
        '/otp',
        arguments: {'email': _emailController.text.trim()},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Text(
                    "Let's help recovery your account",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  ),

                  SizedBox(height: 50.h),

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

                  

                  SizedBox(height: 500.h),

                  ButtonCustom(
                    onPressed: () => _onForgotPasswordPressed(context),
                    text: "Next",
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
                          Navigator.pushNamed(context, '/SignUp');
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
