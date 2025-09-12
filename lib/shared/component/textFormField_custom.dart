import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextformfieldCustom extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const TextformfieldCustom({
    super.key,
    required this.label,
    required this.isPassword,
    required this.controller,
    required this.focusNode,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const TextStyle(color: AppColors.primary);
          }
          return const TextStyle(color: Colors.grey); // khi không focus
        }),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(width: 1.w, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(width: 2.w, color: AppColors.primary),
        ),
      ),
      validator: validator,
    );
  }
}
