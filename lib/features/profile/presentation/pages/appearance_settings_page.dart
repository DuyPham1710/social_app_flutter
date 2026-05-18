import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.iconPrimary,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Giao diện',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tùy chỉnh giao diện',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Chọn chế độ hiển thị phù hợp với mắt của bạn.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 32.h),

              // Option: Sáng
              _buildThemeOption(
                context: context,
                mode: ThemeMode.light,
                title: 'Chế độ Sáng',
                subtitle:
                    'Giao diện nền trắng, chữ đen, phù hợp dùng ban ngày.',
                icon: Icons.light_mode_rounded,
                iconColor: const Color(0xFFF59E0B), // Orange
                isDarkThemeOption: false,
              ),

              SizedBox(height: 16.h),

              // Option: Tối
              _buildThemeOption(
                context: context,
                mode: ThemeMode.dark,
                title: 'Chế độ Tối',
                subtitle:
                    'Giao diện nền đen, chữ trắng, bảo vệ mắt vào ban đêm.',
                icon: Icons.dark_mode_rounded,
                iconColor: const Color(0xFF8B5CF6), // Purple
                isDarkThemeOption: true,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required ThemeMode mode,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool isDarkThemeOption,
  }) {
    // Nếu themeMode là system thì dùng isDark để map sang option Sáng/Tối
    final isDark = s1<AppPreferences>().isDarkMode;
    final currentThemeMode = s1<AppPreferences>().themeMode;
    final isSelected =
        currentThemeMode == mode ||
        (currentThemeMode == ThemeMode.system &&
            ((isDark && mode == ThemeMode.dark) ||
                (!isDark && mode == ThemeMode.light)));

    return GestureDetector(
      onTap: () {
        s1<AppPreferences>().setThemeMode(mode);
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(isDark ? 0.15 : 0.08)
              : (isDark
                    ? Colors.white.withOpacity(0.03)
                    : Colors.black.withOpacity(0.02)),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.05)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28.sp),
            ),
            SizedBox(width: 16.w),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Checkmark or Radio
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
