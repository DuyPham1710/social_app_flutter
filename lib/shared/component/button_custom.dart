import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class ButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ButtonCustom({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.rsr(context)),
          ),
          backgroundColor: AppColors.primary,
        ),

        onPressed: () => onPressed(),

        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.rsp(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
