import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),

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
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.iconPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                l10n.menuPrivacySecurity,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.rsp(context),
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
                  padding: EdgeInsets.all(16.rs(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.profileAccountSecurity,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.rsp(context),
                        ),
                      ),

                      SizedBox(height: 16.rsh(context)),

                      Container(
                        decoration: BoxDecoration(
                          color: itemBgColor,
                          borderRadius: BorderRadius.circular(16.rsr(context)),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          children: [
                            _buildActionItem(
                              context,
                              icon: CupertinoIcons
                                  .person_crop_circle_badge_checkmark,
                              iconColor: Colors.blue,
                              title: l10n.profileFaceData,
                              subtitle: isFaceRegistered
                                  ? l10n.profileFaceRegistered
                                  : l10n.profileFaceNotRegistered,
                              trailing: isFaceRegistered
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 24.rsp(context),
                                    )
                                  : Icon(
                                      Icons.warning_rounded,
                                      color: Colors.orange,
                                      size: 24.rsp(context),
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
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
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
      borderRadius: BorderRadius.circular(16.rsr(context)),
      child: Padding(
        padding: EdgeInsets.all(16.rs(context)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.rs(context)),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24.rsp(context)),
            ),
            SizedBox(width: 16.rs(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.rsp(context),
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.rsh(context)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.rsp(context),
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

  Widget _buildFaceDataContent({
    required BuildContext context,
    required BuildContext mainContext,
    required bool isFaceRegistered,
    required String? userId,
  }) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!ResponsiveHelper.isWebOrDesktop) ...[
          Container(
            width: 40.rs(context),
            height: 4.rsh(context),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2.rsr(context)),
            ),
          ),
          SizedBox(height: 24.rsh(context)),
        ],
        Icon(
          CupertinoIcons.person_crop_circle_badge_checkmark,
          size: 64.rsp(context),
          color: isFaceRegistered ? Colors.green : Colors.blue,
        ),
        SizedBox(height: 16.rsh(context)),
        Text(
          isFaceRegistered
              ? l10n.profileManageFaceData
              : l10n.profileAddFaceData,
          style: TextStyle(
            fontSize: 20.rsp(context),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.rsh(context)),
        Text(
          isFaceRegistered
              ? l10n.profileFaceDataRegisteredDescription
              : l10n.profileFaceDataUnregisteredDescription,
          style: TextStyle(
            fontSize: 14.rsp(context),
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.rsh(context)),
        if (!isFaceRegistered)
          _buildBottomSheetButton(
            context,
            title: l10n.profileAddFaceData,
            icon: Icons.add_a_photo,
            color: Colors.blue,
            onTap: () async {
              Navigator.pop(context); // Đóng bottom sheet/dialog
              if (userId != null) {
                await Navigator.push(
                  mainContext,
                  MaterialPageRoute(
                    builder: (context) =>
                        const FaceRegistrationPage(isPrivacyTab: true),
                    settings: RouteSettings(arguments: {'userId': userId}),
                  ),
                );
                // Khi quay lại từ FaceScanPage, reload lại data
                if (mainContext.mounted) {
                  mainContext.read<ProfileBloc>().add(
                    const LoadUserProfileEvent(),
                  );
                }
              }
            },
          )
        else
          _buildBottomSheetButton(
            context,
            title: l10n.profileDeleteFaceData,
            icon: CupertinoIcons.trash_fill,
            color: Colors.red,
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmationDialog(mainContext);
            },
          ),
        SizedBox(height: 12.rsh(context)),
        _buildBottomSheetButton(
          context,
          title: l10n.commonCancel,
          color: AppColors.textSecondary,
          isOutlined: true,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void _showFaceDataOptions(
    BuildContext context,
    bool isFaceRegistered,
    String? userId,
  ) {
    if (ResponsiveHelper.isWebOrDesktop) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _buildFaceDataContent(
                  context: dialogContext,
                  mainContext: context,
                  isFaceRegistered: isFaceRegistered,
                  userId: userId,
                ),
              ),
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.rsr(context)),
          ),
        ),
        builder: (bottomSheetContext) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.rs(bottomSheetContext),
                vertical: 24.rsh(bottomSheetContext),
              ),
              child: _buildFaceDataContent(
                context: bottomSheetContext,
                mainContext: context,
                isFaceRegistered: isFaceRegistered,
                userId: userId,
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildBottomSheetButton(
    BuildContext context, {
    required String title,
    IconData? icon,
    required Color color,
    required VoidCallback onTap,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50.rsh(context),
      child: isOutlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.rsr(context)),
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.rsp(context),
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
                  borderRadius: BorderRadius.circular(12.rsr(context)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: color, size: 20.rsp(context)),
                    SizedBox(width: 8.rs(context)),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.rsp(context),
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
                          width: 20.rs(context),
                          height: 20.rs(context),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.rs(context)),
                        Expanded(
                          child: Text(
                            context.l10n.profileDeletingFaceData,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.rsp(context),
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
                      borderRadius: BorderRadius.circular(12.rsr(context)),
                    ),
                    margin: EdgeInsets.all(16.rs(context)),
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
