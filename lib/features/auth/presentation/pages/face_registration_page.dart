import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/auth/presentation/widgets/auth_responsive_wrapper.dart';
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
        child: AuthResponsiveWrapper(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.rsh(context)),

                  const AnimatedFaceScan(),

                  SizedBox(height: 32.rsh(context)),

                  Text(
                    context.l10n.faceRecognitionSetup,
                    style: TextStyle(
                      fontSize: 24.rsp(context),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.rsh(context)),

                  Text(
                    context.l10n.faceRecognitionDescription,
                    style: TextStyle(
                      fontSize: 14.rsp(context),
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.rsh(context)),

                  // Feature list
                  _buildFeatureItem(
                    context,
                    icon: CupertinoIcons.person_3_fill,
                    title: context.l10n.faceRecognitionSmartSuggestions,
                    description:
                        context.l10n.faceRecognitionAutoTagDescription,
                  ),
                  SizedBox(height: 20.rsh(context)),
                  _buildFeatureItem(
                    context,
                    icon: CupertinoIcons.shield_fill,
                    title: context.l10n.faceRecognitionAntiSpoofing,
                    description:
                        context.l10n.faceRecognitionAntiSpoofingDescription,
                  ),
                  SizedBox(height: 20.rsh(context)),
                  _buildFeatureItem(
                    context,
                    icon: CupertinoIcons.lock_shield_fill,
                    title: context.l10n.faceRecognitionHighSecurity,
                    description:
                        context.l10n.faceRecognitionSecurityDescription,
                  ),
                  SizedBox(height: 20.rsh(context)),

                  // Bottom Action Buttons
                  Padding(
                    padding: EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      bottom: 20.rsh(context),
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
                        SizedBox(height: 16.rsh(context)),
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
                            padding: EdgeInsets.symmetric(vertical: 12.rsh(context)),
                            child: Text(
                              context.l10n.commonMaybeLater,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16.rsp(context),
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
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
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
          child: Icon(icon, color: AppColors.primary, size: 24.rsp(context)),
        ),
        SizedBox(width: 16.rs(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.rsp(context),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.rsh(context)),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13.rsp(context),
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
      width: 120.rs(context),
      height: 120.rs(context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.05),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 2.rs(context),
        ),
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              CupertinoIcons.person_crop_circle,
              size: 80.rs(context),
              color: AppColors.primary.withOpacity(0.5),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  top: (_controller.value * 140.rs(context)) - 20.rs(context),
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40.rs(context),
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
                        height: 2.rs(context),
                        color: AppColors.primary,
                        margin: EdgeInsets.symmetric(horizontal: 10.rs(context)),
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
