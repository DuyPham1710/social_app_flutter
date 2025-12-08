import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class StoriesLoadingWidget extends StatelessWidget {
  const StoriesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.w,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddStoryLoading();
          }
          return _buildStoryLoadingItem();
        },
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemCount: 6, // Add story + 5 story items
      ),
    );
  }

  Widget _buildAddStoryLoading() {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 120.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
        ),
        SizedBox(height: 30.h),
        Container(
          width: 60.w,
          height: 12.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildStoryLoadingItem() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 80.w,
              height: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: AppColors.textSecondary.withOpacity(0.3),
              ),
            ),
            // Avatar loading
            Positioned(
              bottom: -18.h,
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textSecondary.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        Container(
          width: 60.w,
          height: 12.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
