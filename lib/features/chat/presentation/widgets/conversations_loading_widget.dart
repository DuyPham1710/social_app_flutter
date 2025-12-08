import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class ConversationsLoadingWidget extends StatelessWidget {
  const ConversationsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(children: List.generate(8, (index) => _buildLoadingItem())),
    );
  }

  Widget _buildLoadingItem() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          // Avatar loading
          Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
          ),
          SizedBox(width: 12.w),
          // Content loading
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name loading
                Container(
                  width: 120.w, // Fixed width instead of percentage
                  height: 16.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.textSecondary.withOpacity(0.3),
                  ),
                ),
                SizedBox(height: 6.h),
                // Message loading
                Container(
                  width: 200.w, // Fixed width instead of percentage
                  height: 14.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: AppColors.textSecondary.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Time loading
          Container(
            width: 40.w,
            height: 12.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
