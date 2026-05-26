import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/shared/component/button_custom.dart';
import 'package:social_app_fe/l10n/l10n.dart';
class FaceRegistrationPage extends StatelessWidget {
  final bool isPrivacyTab;

  const FaceRegistrationPage({super.key, this.isPrivacyTab = false});

  @override
  Widget build(BuildContext context) {
    // Lấy userId từ route arguments (truyền từ personal_info_page)
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final userId = args?['userId'] as String? ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),

                const AnimatedFaceScan(),

                SizedBox(height: 32.h),

                Text(
                  context.l10n.faceRecognitionSetup,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),

                Text(
                  context.l10n.faceRecognitionDescription,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),

                // Feature list
                _buildFeatureItem(
                  icon: CupertinoIcons.person_3_fill,
                  title: context.l10n.faceRecognitionSmartSuggestions,
                  description:
                      context.l10n.faceRecognitionAutoTagDescription,
                ),
                SizedBox(height: 20.h),
                _buildFeatureItem(
                  icon: CupertinoIcons.shield_fill,
                  title: context.l10n.faceRecognitionAntiSpoofing,
                  description:
                      context.l10n.faceRecognitionAntiSpoofingDescription,
                ),
                SizedBox(height: 20.h),
                _buildFeatureItem(
                  icon: CupertinoIcons.lock_shield_fill,
                  title: context.l10n.faceRecognitionHighSecurity,
                  description:
                      context.l10n.faceRecognitionSecurityDescription,
                ),
                SizedBox(height: 20.h),

                // Bottom Action Buttons
                Padding(
                  padding: EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 20.h,
                  ),
                  child: Column(
                    children: [
                      ButtonCustom(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/face-scan',
                            arguments: {
                              'userId': userId,
                              'isPrivacyTab': isPrivacyTab,
                            },
                          );
                        },
                        text: context.l10n.faceRecognitionStartScan,
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () {
                          if (isPrivacyTab) {
                            Navigator.pop(context);
                          } else {
                            // Skip face registration and navigate to login
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Text(
                            context.l10n.commonMaybeLater,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24.sp),
        ),
        SizedBox(width: 16.w),
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
                description,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedFaceScan extends StatefulWidget {
  const AnimatedFaceScan({super.key});

  @override
  State<AnimatedFaceScan> createState() => _AnimatedFaceScanState();
}

class _AnimatedFaceScanState extends State<AnimatedFaceScan>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.05),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 2.w,
        ),
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              CupertinoIcons.person_crop_circle,
              size: 80.w,
              color: AppColors.primary.withOpacity(0.5),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  top: (_controller.value * 140.w) - 20.w,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withOpacity(0.0),
                          AppColors.primary.withOpacity(0.4),
                          AppColors.primary.withOpacity(0.0),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 2.w,
                        color: AppColors.primary,
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
