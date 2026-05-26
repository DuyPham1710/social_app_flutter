import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/presentation/pages/face_registration_page.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_state.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_dialog_success.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;
    final itemBgColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.02);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.menuPrivacySecurity,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            if (state.deleteFaceSuccess) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              showDialogSuccess(
                context,
                context.l10n.profileFaceDataSuccessDeleted,
                isNavigateLogin: false,
              );
            } else if (state.deleteFaceError != null) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              showErrorSnackBar(context, state.deleteFaceError!);
            }
          }
        },
        builder: (context, state) {
          final user = state.user;
          final isFaceRegistered = user?.isFaceRegistered ?? false;
          print('User: $user, Face Registered: $isFaceRegistered');
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profileAccountSecurity,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),

                SizedBox(height: 16.h),

                Container(
                  decoration: BoxDecoration(
                    color: itemBgColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      _buildActionItem(
                        icon: CupertinoIcons.person_crop_circle_badge_checkmark,
                        iconColor: Colors.blue,
                        title: l10n.profileFaceData,
                        subtitle: isFaceRegistered
                            ? l10n.profileFaceRegistered
                            : l10n.profileFaceNotRegistered,
                        trailing: isFaceRegistered
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 24.sp,
                              )
                            : Icon(
                                Icons.warning_rounded,
                                color: Colors.orange,
                                size: 24.sp,
                              ),
                        onTap: () {
                          _showFaceDataOptions(
                            context,
                            isFaceRegistered,
                            user?.userId,
                          );
                        },
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showFaceDataOptions(
    BuildContext context,
    bool isFaceRegistered,
    String? userId,
  ) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 24.h),
                Icon(
                  CupertinoIcons.person_crop_circle_badge_checkmark,
                  size: 64.sp,
                  color: isFaceRegistered ? Colors.green : Colors.blue,
                ),
                SizedBox(height: 16.h),
                Text(
                  isFaceRegistered
                      ? l10n.profileManageFaceData
                      : l10n.profileAddFaceData,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  isFaceRegistered
                      ? l10n.profileFaceDataRegisteredDescription
                      : l10n.profileFaceDataUnregisteredDescription,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                if (!isFaceRegistered)
                  _buildBottomSheetButton(
                    title: l10n.profileAddFaceData,
                    icon: Icons.add_a_photo,
                    color: Colors.blue,
                    onTap: () async {
                      Navigator.pop(bottomSheetContext); // Đóng bottom sheet
                      if (userId != null) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const FaceRegistrationPage(isPrivacyTab: true),
                            settings: RouteSettings(
                              arguments: {'userId': userId},
                            ),
                          ),
                        );
                        // Khi quay lại từ FaceScanPage, reload lại data
                        if (context.mounted) {
                          context.read<ProfileBloc>().add(
                            const LoadUserProfileEvent(),
                          );
                        }
                      }
                    },
                  )
                else
                  _buildBottomSheetButton(
                    title: l10n.profileDeleteFaceData,
                    icon: CupertinoIcons.trash_fill,
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      _showDeleteConfirmationDialog(context);
                    },
                  ),
                SizedBox(height: 12.h),
                _buildBottomSheetButton(
                  title: l10n.commonCancel,
                  color: AppColors.textSecondary,
                  isOutlined: true,
                  onTap: () => Navigator.pop(bottomSheetContext),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetButton({
    required String title,
    IconData? icon,
    required Color color,
    required VoidCallback onTap,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color.withOpacity(0.1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: color, size: 20.sp),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            context.l10n.profileDeleteConfirmTitle,
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Text(
            context.l10n.profileDeleteFaceConfirmMessage,
            style: TextStyle(color: AppColors.textPrimary),
          ),
          actions: [
            TextButton(
              child: Text(
                context.l10n.commonCancel,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: Text(
                context.l10n.commonDelete,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(dialogContext); // Đóng dialog

                // Dispatch event
                context.read<ProfileBloc>().add(const DeleteFaceDataEvent());

                // Show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            context.l10n.profileDeletingFaceData,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    margin: EdgeInsets.all(16.w),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
