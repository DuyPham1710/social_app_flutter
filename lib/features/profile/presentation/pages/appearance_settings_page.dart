import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/l10n/generated/app_localizations.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  late Color _selectedAccentColor;
  late String _selectedAccentKey;

  // Local state for text size slider
  double _textSizeSliderValue = 2.0;

  // Local state for additional toggles
  bool _highContrast = false;
  bool _reduceMotion = false;

  final List<Map<String, dynamic>> _accentColors = [
    {'key': 'default', 'color': AppColors.defaultPrimary},
    {'key': 'blue', 'color': const Color(0xFF1877F2)},
    {'key': 'pinkPurple', 'color': const Color(0xFFD62976)},
    {'key': 'neonPurple', 'color': const Color(0xFF8B5CF6)},
    {'key': 'brightOrange', 'color': const Color(0xFFFF7F50)},
    {'key': 'coralRed', 'color': const Color(0xFFFF3B5C)},
  ];

  @override
  void initState() {
    super.initState();
    final prefs = s1<AppPreferences>();
    _selectedAccentColor = prefs.accentColor;

    final accentColorItem = _accentColors.firstWhere(
      (element) =>
          (element['color'] as Color).value == _selectedAccentColor.value,
      orElse: () => {'key': 'custom', 'color': _selectedAccentColor},
    );
    _selectedAccentKey = accentColorItem['key'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final prefs = s1<AppPreferences>();

    return ListenableBuilder(
      listenable: prefs,
      builder: (context, _) {
        final isDark = prefs.isDarkMode;
        final currentThemeMode = prefs.themeMode;
        final l10n = context.l10n;

        return Container(
          color: AppColors.background,

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: ResponsiveHelper.feedMaxWidth,
              ),

              child: Scaffold(
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
                      size: 20.rsp(context),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    l10n.menuAppearance,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18.rsp(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                body: SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.rs(context),
                      vertical: 16.rsh(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(l10n.appearanceDisplayModeSection),
                        SizedBox(height: 12.rsh(context)),
                        Row(
                          children: [
                            // Light mode option
                            Expanded(
                              child: _buildThemeOptionCard(
                                title: l10n.appearanceLightMode,
                                isSelected: currentThemeMode == ThemeMode.light,
                                onTap: () =>
                                    prefs.setThemeMode(ThemeMode.light),
                                previewWidget: _buildLightCardPreview(),
                              ),
                            ),
                            SizedBox(width: 12.rs(context)),
                            // Dark mode option
                            Expanded(
                              child: _buildThemeOptionCard(
                                title: l10n.appearanceDarkMode,
                                isSelected: currentThemeMode == ThemeMode.dark,
                                onTap: () => prefs.setThemeMode(ThemeMode.dark),
                                previewWidget: _buildDarkCardPreview(),
                              ),
                            ),
                            SizedBox(width: 12.rs(context)),
                            // Auto/System mode option
                            Expanded(
                              child: _buildThemeOptionCard(
                                title: l10n.appearanceAutoMode,
                                isSelected:
                                    currentThemeMode == ThemeMode.system,
                                onTap: () =>
                                    prefs.setThemeMode(ThemeMode.system),
                                previewWidget: _buildAutoCardPreview(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 28.rsh(context)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle(
                              l10n.appearanceAccentColorSection,
                            ),
                            Text(
                              _accentName(l10n, _selectedAccentKey),
                              style: TextStyle(
                                color: _selectedAccentColor,
                                fontSize: 14.rsp(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.rsh(context)),
                        _buildAccentColorPicker(isDark),
                        SizedBox(height: 28.rsh(context)),

                        _buildSectionTitle(l10n.appearanceTextSizeSection),
                        SizedBox(height: 12.rsh(context)),
                        _buildTextSizeCard(isDark),
                        SizedBox(height: 28.rsh(context)),

                        _buildAccessibilityCard(isDark),
                        SizedBox(height: 24.rsh(context)),
                      ],
                    ),
                  ),
                ),
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
        fontSize: 11.rsp(context),
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
            height: 120.rsh(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.rsr(context)),
              border: Border.all(
                color: isSelected
                    ? _selectedAccentColor
                    : Colors.black.withOpacity(0.08),
                width: isSelected ? 2.rs(context) : 1.rs(context),
              ),
            ),
            child: previewWidget,
          ),
          SizedBox(height: 8.rsh(context)),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12.rsp(context),
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
        borderRadius: BorderRadius.circular(10.rsr(context)),
      ),
      padding: EdgeInsets.all(8.rs(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 12.rsh(context),
            width: 35.rs(context),
            decoration: BoxDecoration(
              color: const Color(0xFFE1E3E4),
              borderRadius: BorderRadius.circular(6.rsr(context)),
            ),
          ),
          SizedBox(height: 6.rsh(context)),
          Container(
            height: 8.rsh(context),
            width: 20.rs(context),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEEEF),
              borderRadius: BorderRadius.circular(4.rsr(context)),
            ),
          ),
          const Spacer(),
          Container(
            height: 24.rsh(context),
            width: double.infinity,
            decoration: BoxDecoration(
              color: _selectedAccentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6.rsr(context)),
              border: Border.all(
                color: _selectedAccentColor.withOpacity(0.3),
                width: 1.rs(context),
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
        borderRadius: BorderRadius.circular(10.rsr(context)),
      ),
      padding: EdgeInsets.all(8.rs(context)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 12.rsh(context),
            width: 35.rs(context),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.rsr(context)),
            ),
          ),
          SizedBox(height: 6.rsh(context)),
          Container(
            height: 8.rsh(context),
            width: 20.rs(context),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4.rsr(context)),
            ),
          ),
          const Spacer(),
          Container(
            height: 24.rsh(context),
            width: double.infinity,
            decoration: BoxDecoration(
              color: _selectedAccentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6.rsr(context)),
              border: Border.all(
                color: _selectedAccentColor.withOpacity(0.3),
                width: 1.rs(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoCardPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.rsr(context)),
      child: Row(
        children: [
          // Left side: light half
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(8.rs(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12.rsh(context),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1E3E4),
                      borderRadius: BorderRadius.circular(6.rsr(context)),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 24.rsh(context),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _selectedAccentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6.rsr(context)),
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
              padding: EdgeInsets.all(8.rs(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12.rsh(context),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.rsr(context)),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 24.rsh(context),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _selectedAccentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6.rsr(context)),
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
      padding: EdgeInsets.all(12.rs(context)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.rsr(context)),
        border: Border.all(color: AppColors.divider, width: 1.rs(context)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 8.rs(context),
        runSpacing: 8.rsh(context),
        children:
            _accentColors.map((swatch) {
              final color = swatch['color'] as Color;
              final key = swatch['key'] as String;
              final isSelected = _selectedAccentColor.value == color.value;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAccentColor = color;
                    _selectedAccentKey = key;
                  });
                  s1<AppPreferences>().setAccentColor(color);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36.rs(context),
                  height: 36.rs(context),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? (isDark ? Colors.white : Colors.black)
                          : Colors.transparent,
                      width: isSelected ? 2.rs(context) : 0.rs(context),
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
                  width: 36.rs(context),
                  height: 36.rs(context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.divider,
                      width: 1.rs(context),
                    ),
                    color: AppColors.secondBackground,
                  ),
                  child: Icon(
                    Icons.color_lens_outlined,
                    size: 20.rsp(context),
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
            context.l10n.appearanceChooseAccentColor,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.rsp(context),
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
                context.l10n.commonCancel,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedAccentColor = tempColor;
                  _selectedAccentKey = 'custom';
                });
                s1<AppPreferences>().setAccentColor(tempColor);
                Navigator.pop(context);
              },
              child: Text(
                context.l10n.commonChoose,
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
      padding: EdgeInsets.all(16.rs(context)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.rsr(context)),
        border: Border.all(color: AppColors.divider, width: 1.rs(context)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'A',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12.rsp(context),
                ),
              ),
              Text(
                'A',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.rsp(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'A',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20.rsp(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.rsh(context)),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _selectedAccentColor,
              inactiveTrackColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFEDEEEF),
              thumbColor: _selectedAccentColor,
              overlayColor: _selectedAccentColor.withOpacity(0.12),
              trackHeight: 6.rsh(context),
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 10.rsr(context),
              ),
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
          SizedBox(height: 8.rsh(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.appearanceSmallText,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.rsp(context),
                ),
              ),
              Text(
                context.l10n.appearanceNormalText,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.rsp(context),
                ),
              ),
              Text(
                context.l10n.appearanceLargeText,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.rsp(context),
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
        borderRadius: BorderRadius.circular(16.rsr(context)),
        border: Border.all(color: AppColors.divider, width: 1.rs(context)),
      ),
      child: Column(
        children: [
          // Contrast toggle
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.rs(context),
              vertical: 12.rsh(context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.appearanceHighContrast,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.rsp(context),
                  ),
                ),
                Switch(
                  value: _highContrast,
                  activeColor: _selectedAccentColor,
                  activeTrackColor: _selectedAccentColor.withOpacity(0.4),
                  inactiveThumbColor: isDark ? Colors.grey[400] : Colors.white,
                  inactiveTrackColor: isDark
                      ? const Color(0xFF333333)
                      : const Color(0xFFE0E0E0),
                  trackOutlineColor: WidgetStateProperty.all(
                    Colors.transparent,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _highContrast = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.divider,
            height: 1.rsh(context),
            thickness: 1.rsh(context),
          ),
          // Reduce motion toggle
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.rs(context),
              vertical: 12.rsh(context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.appearanceReduceMotion,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.rsp(context),
                  ),
                ),
                Switch(
                  value: _reduceMotion,
                  activeColor: _selectedAccentColor,
                  activeTrackColor: _selectedAccentColor.withOpacity(0.4),
                  inactiveThumbColor: isDark ? Colors.grey[400] : Colors.white,
                  inactiveTrackColor: isDark
                      ? const Color(0xFF333333)
                      : const Color(0xFFE0E0E0),
                  trackOutlineColor: WidgetStateProperty.all(
                    Colors.transparent,
                  ),
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

  String _accentName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'default':
        return l10n.appearanceDefaultAccent;
      case 'blue':
        return l10n.appearanceBlueAccent;
      case 'pinkPurple':
        return l10n.appearancePinkPurpleAccent;
      case 'neonPurple':
        return l10n.appearanceNeonPurpleAccent;
      case 'brightOrange':
        return l10n.appearanceBrightOrangeAccent;
      case 'coralRed':
        return l10n.appearanceCoralRedAccent;
    }
    return l10n.appearanceCustomAccentColor;
  }
}
