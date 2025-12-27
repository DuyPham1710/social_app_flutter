import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class ChangeAvatarDialog extends StatelessWidget {
  const ChangeAvatarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      title: Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Text(
          'Đổi ảnh nhóm',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption(
              context: context,
              icon: CupertinoIcons.camera_fill,
              label: 'Chụp ảnh',
              onTap: () {
                Navigator.pop(context);
                // Xử lý chụp ảnh
              },
            ),
            SizedBox(height: 8.h),
            _buildDialogOption(
              context: context,
              icon: CupertinoIcons.photo_fill,
              label: 'Chọn ảnh',
              onTap: () {
                Navigator.pop(context);
                // Xử lý chọn ảnh từ thư viện
              },
            ),
            SizedBox(height: 8.h),
            _buildDialogOption(
              context: context,
              icon: CupertinoIcons.sparkles,
              label: 'Tạo ảnh',
              onTap: () {
                Navigator.pop(context);
                // Xử lý tạo ảnh AI
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 22.sp),
            SizedBox(width: 16.w),
            Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
