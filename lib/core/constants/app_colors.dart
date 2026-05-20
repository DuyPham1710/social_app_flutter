import 'package:flutter/material.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';

class AppColors {
  static Color get primary => s1<AppPreferences>().accentColor;
  static const Color defaultPrimary = Color.fromARGB(255, 36, 175, 177);

  static Color get textPrimary =>
      s1<AppPreferences>().isDarkMode ? Colors.white : const Color(0xFF000000);

  static Color get textSecondary => s1<AppPreferences>().isDarkMode
      ? Colors.grey[400]!
      : const Color(0xFF666666);

  static Color get iconPrimary =>
      s1<AppPreferences>().isDarkMode ? Colors.white : const Color(0xFF000000);

  static Color get background => s1<AppPreferences>().isDarkMode
      ? const Color(0xFF121212)
      : const Color(0xFFFFFFFF);

  static Color get secondBackground => s1<AppPreferences>().isDarkMode
      ? const Color(0xFF1E1E1E)
      : const Color(0xFFf1f1f1);

  static Color get unselectedIcon => s1<AppPreferences>().isDarkMode
      ? Colors.white.withOpacity(0.5)
      : Colors.black.withOpacity(0.5);

  static Color get divider =>
      s1<AppPreferences>().isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;

  static Color get backgroundCommentItem => s1<AppPreferences>().isDarkMode
      ? const Color(0xFF2C2C2C)
      : const Color(0xfff3f2f7);
}
