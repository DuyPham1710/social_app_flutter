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
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent, // Remove pink tint
              headerBackgroundColor: AppColors.primary,
              headerForegroundColor: Colors.white,
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary, // màu nút OK, viền, header
              onPrimary: Colors.white, // màu chữ trong header
              onSurface: AppColors.textPrimary, // màu text ngày
              onSurfaceVariant:
                  AppColors.textSecondary, // màu text năm chưa chọn
              surface: AppColors.background, // nền lịch
              surfaceTint: Colors.transparent,
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
