import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  late Color _selectedAccentColor;
  late String _selectedAccentName;

  // Local state for text size slider
  double _textSizeSliderValue = 2.0;

  // Local state for additional toggles
  bool _highContrast = false;
  bool _reduceMotion = false;

  final List<Map<String, dynamic>> _accentColors = [
    {'name': 'Mặc định', 'color': AppColors.defaultPrimary},
    {'name': 'Xanh Dương', 'color': const Color(0xFF1877F2)},
    {'name': 'Hồng Tím', 'color': const Color(0xFFD62976)},
    {'name': 'Tím Neon', 'color': const Color(0xFF8B5CF6)},
    {'name': 'Cam Sáng', 'color': const Color(0xFFFF7F50)},
    {'name': 'Đỏ Coral', 'color': const Color(0xFFFF3B5C)},
  ];

  @override
  void initState() {
    super.initState();
    final prefs = s1<AppPreferences>();
    _selectedAccentColor = prefs.accentColor;

    final accentColorItem = _accentColors.firstWhere(
      (element) =>
          (element['color'] as Color).value == _selectedAccentColor.value,
      orElse: () => {'name': 'Tùy chỉnh', 'color': _selectedAccentColor},
    );
    _selectedAccentName = accentColorItem['name'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final prefs = s1<AppPreferences>();

    return ListenableBuilder(
      listenable: prefs,
      builder: (context, _) {
        final isDark = prefs.isDarkMode;
        final currentThemeMode = prefs.themeMode;

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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('CHẾ ĐỘ HIỂN THỊ'),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      // Light mode option
                      Expanded(
                        child: _buildThemeOptionCard(
                          title: 'Sáng',
                          isSelected: currentThemeMode == ThemeMode.light,
                          onTap: () => prefs.setThemeMode(ThemeMode.light),
                          previewWidget: _buildLightCardPreview(),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Dark mode option
                      Expanded(
                        child: _buildThemeOptionCard(
                          title: 'Tối',
                          isSelected: currentThemeMode == ThemeMode.dark,
                          onTap: () => prefs.setThemeMode(ThemeMode.dark),
                          previewWidget: _buildDarkCardPreview(),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Auto/System mode option
                      Expanded(
                        child: _buildThemeOptionCard(
                          title: 'Tự động',
                          isSelected: currentThemeMode == ThemeMode.system,
                          onTap: () => prefs.setThemeMode(ThemeMode.system),
                          previewWidget: _buildAutoCardPreview(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('MÀU CHỦ ĐẠO'),
                      Text(
                        _selectedAccentName,
                        style: TextStyle(
                          color: _selectedAccentColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildAccentColorPicker(isDark),
                  SizedBox(height: 28.h),

                  _buildSectionTitle('KÍCH THƯỚC CHỮ'),
                  SizedBox(height: 12.h),
                  _buildTextSizeCard(isDark),
                  SizedBox(height: 28.h),

                  _buildAccessibilityCard(isDark),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildThemeOptionCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required Widget previewWidget,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected
                    ? _selectedAccentColor
                    : Colors.black.withOpacity(0.08),
                width: isSelected ? 2.w : 1.w,
              ),
            ),
            child: previewWidget,
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLightCardPreview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 12.h,
            width: 35.w,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E3E4),
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            height: 8.h,
            width: 20.w,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEEEF),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          const Spacer(),
          Container(
            height: 24.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _selectedAccentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: _selectedAccentColor.withOpacity(0.3),
                width: 1.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkCardPreview() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2E3132),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.all(8.w),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 12.h,
            width: 35.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            height: 8.h,
            width: 20.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          const Spacer(),
          Container(
            height: 24.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _selectedAccentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: _selectedAccentColor.withOpacity(0.3),
                width: 1.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoCardPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Row(
        children: [
          // Left side: light half
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1E3E4),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 24.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _selectedAccentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right side: dark half
          Expanded(
            child: Container(
              color: const Color(0xFF2E3132),
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 24.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _selectedAccentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccentColorPicker(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 8.w,
        runSpacing: 8.h,
        children:
            _accentColors.map((swatch) {
              final color = swatch['color'] as Color;
              final name = swatch['name'] as String;
              final isSelected = _selectedAccentColor.value == color.value;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAccentColor = color;
                    _selectedAccentName = name;
                  });
                  s1<AppPreferences>().setAccentColor(color);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? (isDark ? Colors.white : Colors.black)
                          : Colors.transparent,
                      width: isSelected ? 2.w : 0.w,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            }).toList()..add(
              GestureDetector(
                onTap: () => _showColorPicker(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.divider, width: 1.w),
                    color: AppColors.secondBackground,
                  ),
                  child: Icon(
                    Icons.color_lens_outlined,
                    size: 20.sp,
                    color: AppColors.iconPrimary,
                  ),
                ),
              ),
            ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    Color tempColor = _selectedAccentColor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'Chọn màu chủ đạo',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                tempColor = color;
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              //     paletteType: PaletteType.hsvWithHue,
              paletteType: PaletteType.hueWheel,
              labelTypes: const [],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Hủy',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedAccentColor = tempColor;
                  _selectedAccentName = 'Tùy chỉnh';
                });
                s1<AppPreferences>().setAccentColor(tempColor);
                Navigator.pop(context);
              },
              child: Text(
                'Chọn',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextSizeCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'A',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 12.sp),
              ),
              Text(
                'A',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'A',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _selectedAccentColor,
              inactiveTrackColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFEDEEEF),
              thumbColor: _selectedAccentColor,
              overlayColor: _selectedAccentColor.withOpacity(0.12),
              trackHeight: 6.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
            ),
            child: Slider(
              value: _textSizeSliderValue,
              min: 1.0,
              max: 3.0,
              divisions: 2,
              onChanged: (value) {
                setState(() {
                  _textSizeSliderValue = value;
                });
              },
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nhỏ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
              Text(
                'Bình thường',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
              Text(
                'Lớn',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityCard(bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
      ),
      child: Column(
        children: [
          // Contrast toggle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Độ tương phản cao',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                Switch(
                  value: _highContrast,
                  activeColor: _selectedAccentColor,
                  activeTrackColor: _selectedAccentColor.withOpacity(0.4),
                  inactiveThumbColor: isDark ? Colors.grey[400] : Colors.white,
                  inactiveTrackColor: isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0),
                  trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                  onChanged: (value) {
                    setState(() {
                      _highContrast = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Divider(color: AppColors.divider, height: 1.h, thickness: 1.h),
          // Reduce motion toggle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Giảm chuyển động',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                Switch(
                  value: _reduceMotion,
                  activeColor: _selectedAccentColor,
                  activeTrackColor: _selectedAccentColor.withOpacity(0.4),
                  inactiveThumbColor: isDark ? Colors.grey[400] : Colors.white,
                  inactiveTrackColor: isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0),
                  trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                  onChanged: (value) {
                    setState(() {
                      _reduceMotion = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
