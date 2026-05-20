import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class PostCreatingProgress extends StatelessWidget {
  final double? progress; // 0.0 - 1.0 (tùy bạn có muốn tính % không)

  const PostCreatingProgress({super.key, this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              progress != null
                  ? "Đang đăng bài... ${(progress! * 100).toStringAsFixed(0)}%"
                  : "Đang đăng bài...",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
