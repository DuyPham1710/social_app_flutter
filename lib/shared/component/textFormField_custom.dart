import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class TextformfieldCustom extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final double? width;
  final VoidCallback? onTap;
  final bool readOnly;

  const TextformfieldCustom({
    super.key,
    required this.label,
    required this.isPassword,
    required this.controller,
    required this.focusNode,
    this.validator,
    this.suffixIcon,
    this.width = double.infinity,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword,
        style: TextStyle(color: AppColors.textPrimary),
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.textSecondary),
          floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return TextStyle(color: AppColors.primary);
            }
            return TextStyle(color: AppColors.textSecondary); // khi không focus
          }),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.rsr(context)),
          ),
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.rsr(context)),
            borderSide: BorderSide(
              width: 1.rs(context),
              color: AppColors.divider,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.rsr(context)),
            borderSide: BorderSide(
              width: 2.rs(context),
              color: AppColors.primary,
            ),
          ),
        ),
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }
}
