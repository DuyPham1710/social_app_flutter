import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class DeleteMessageBottomSheet {
  static void show({
    required BuildContext context,
    required bool isMyMessage,
    required VoidCallback onDeleteForEveryone,
    required VoidCallback onDeleteForMe,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DeleteMessageContent(
        isMyMessage: isMyMessage,
        onDeleteForEveryone: onDeleteForEveryone,
        onDeleteForMe: onDeleteForMe,
      ),
    );
  }
}

class _DeleteMessageContent extends StatelessWidget {
  final bool isMyMessage;
  final VoidCallback onDeleteForEveryone;
  final VoidCallback onDeleteForMe;

  const _DeleteMessageContent({
    required this.isMyMessage,
    required this.onDeleteForEveryone,
    required this.onDeleteForMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
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
                      'Xóa tin nhắn?',
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
                text: 'Xóa đối với mọi người',
                onTap: () {
                  Navigator.of(context).pop();
                  onDeleteForEveryone();
                },
              ),
              SizedBox(height: 8.h),
            ],
            _DeleteOption(
              icon: CupertinoIcons.trash_fill,
              text: 'Xóa cho tôi',
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
