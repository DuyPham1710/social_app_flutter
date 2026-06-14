import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/shared/helpers/show_info_snackBar.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class AttachmentMenuWidget extends StatelessWidget {
  final VoidCallback onClose;
  final Future<void> Function()? onShareLocation;
  final Future<void> Function()? onShareFile;
  final VoidCallback? onPickGiphy;

  const AttachmentMenuWidget({
    super.key,
    required this.onClose,
    this.onShareLocation,
    this.onShareFile,
    this.onPickGiphy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      width: 200.w,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          _buildAttachmentMenuItem(
            context: context,
            title: context.l10n.chatShareFile,
            icon: CupertinoIcons.doc_fill,
            color: AppColors.primary,
            onTap: () {
              onClose();
              onShareFile?.call();
            },
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Divider(color: AppColors.divider, height: 1, thickness: 1),
          ),

          if (!ResponsiveHelper.isWebOrDesktop) ...[
            _buildAttachmentMenuItem(
              context: context,
              title: context.l10n.messageLocation,
              icon: CupertinoIcons.location_solid,
              color: AppColors.primary,
              onTap: () {
                onClose();
                onShareLocation?.call();
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Divider(color: AppColors.divider, height: 1, thickness: 1),
            ),
          ],

          _buildAttachmentMenuItem(
            context: context,
            title: context.l10n.chatAiImages,
            icon: CupertinoIcons.sparkles,
            color: AppColors.primary,
            onTap: () {
              onClose();
              showInfoSnackBar(
                context,
                context.l10n.chatAiImagesInDevelopmentMessage,
              );
            },
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Divider(color: AppColors.divider, height: 1, thickness: 1),
          ),

          _buildAttachmentMenuItem(
            context: context,
            title: context.l10n.chatGiphySticker,
            icon: CupertinoIcons.smiley,
            color: AppColors.primary,
            onTap: () {
              onClose();
              onPickGiphy?.call();
            },
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildAttachmentMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(icon, color: color, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
