import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';

import 'package:social_app_fe/core/utils/responsive_helper.dart';

class DeleteMessageBottomSheet {
  static void show({
    required BuildContext context,
    required bool isMyMessage,
    required VoidCallback onDeleteForEveryone,
    required VoidCallback onDeleteForMe,
  }) {
    if (ResponsiveHelper.isWebOrDesktop) {
      showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),

            child: _DeleteMessageContent(
              isMyMessage: isMyMessage,
              onDeleteForEveryone: onDeleteForEveryone,
              onDeleteForMe: onDeleteForMe,
              isDialog: true,
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => _DeleteMessageContent(
          isMyMessage: isMyMessage,
          onDeleteForEveryone: onDeleteForEveryone,
          onDeleteForMe: onDeleteForMe,
          isDialog: false,
        ),
      );
    }
  }
}

class _DeleteMessageContent extends StatelessWidget {
  final bool isMyMessage;
  final VoidCallback onDeleteForEveryone;
  final VoidCallback onDeleteForMe;
  final bool isDialog;

  const _DeleteMessageContent({
    required this.isMyMessage,
    required this.onDeleteForEveryone,
    required this.onDeleteForMe,
    required this.isDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: isDialog
            ? BorderRadius.circular(20.r)
            : BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
            if (!isDialog)
              Container(
                margin: EdgeInsets.only(top: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      context.l10n.chatDeleteMessageTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
            ),
            // Options
            if (isMyMessage) ...[
              _DeleteOption(
                icon: CupertinoIcons.trash_fill,
                text: context.l10n.chatDeleteForEveryone,
                onTap: () {
                  Navigator.of(context).pop();
                  onDeleteForEveryone();
                },
              ),
              SizedBox(height: 8.h),
            ],
            _DeleteOption(
              icon: CupertinoIcons.trash_fill,
              text: context.l10n.chatDeleteForMe,
              onTap: () {
                Navigator.of(context).pop();
                onDeleteForMe();
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class _DeleteOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _DeleteOption({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: Colors.red, size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
