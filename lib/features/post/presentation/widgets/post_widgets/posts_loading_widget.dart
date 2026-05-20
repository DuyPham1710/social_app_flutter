import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class PostsLoadingWidget extends StatelessWidget {
  const PostsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => _buildPostLoadingItem()),
    );
  }

  Widget _buildPostLoadingItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and name
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textSecondary.withOpacity(0.3),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.textSecondary.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: 80.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColors.textSecondary.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Post content
          Container(
            width: double.infinity,
            height: 14.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: AppColors.textSecondary.withOpacity(0.2),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: 0.7.sw,
            height: 14.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: AppColors.textSecondary.withOpacity(0.2),
            ),
          ),
          SizedBox(height: 12.h),

          // Post image placeholder
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.textSecondary.withOpacity(0.2),
            ),
          ),
          SizedBox(height: 12.h),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              3,
              (index) => Container(
                width: 60.w,
                height: 32.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.textSecondary.withOpacity(0.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
