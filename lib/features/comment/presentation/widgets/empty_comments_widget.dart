import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class EmptyCommentsWidget extends StatelessWidget {
  final VoidCallback? onTapToComment;

  const EmptyCommentsWidget({super.key, this.onTapToComment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64.w,
            color: AppColors.unselectedIcon,
          ),

          SizedBox(height: 16.h),

          Text(
            context.l10n.commentEmptyTitle,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          Text(
            context.l10n.commentEmptySubtitle,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),

          if (onTapToComment != null) ...[
            SizedBox(height: 24.h),

            ElevatedButton.icon(
              onPressed: onTapToComment,
              icon: Icon(Icons.edit_outlined, size: 18.w, color: Colors.white),
              label: Text(
                context.l10n.commentWriteFirst,
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
