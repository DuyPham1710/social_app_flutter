import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class DatePickerWidget {
  static Future<DateTime?> show(BuildContext context) {
    return showDatePicker(
      context: context,

      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary, // màu nút OK, viền, header
              onPrimary: Colors.white, // màu chữ trong header
              onSurface: Colors.black, // màu text ngày
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary, // màu nút Cancel/OK
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
