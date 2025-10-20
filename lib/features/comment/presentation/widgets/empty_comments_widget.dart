import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

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
          Icon(Icons.chat_bubble_outline, size: 64.w, color: Colors.grey[400]),

          SizedBox(height: 16.h),

          Text(
            'Chưa có bình luận nào',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          Text(
            'Hãy là người đầu tiên bình luận về bài viết này',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),

          if (onTapToComment != null) ...[
            SizedBox(height: 24.h),

            ElevatedButton.icon(
              onPressed: onTapToComment,
              icon: Icon(Icons.edit_outlined, size: 18.w),
              label: Text(
                'Viết bình luận đầu tiên',
                style: TextStyle(fontSize: 14.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
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
