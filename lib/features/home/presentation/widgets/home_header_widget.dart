import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.all(16.0.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Home',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),

          Row(
            children: [
              IconButton(
                icon: const Icon(
                  CupertinoIcons.search,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  // Handle search action
                },
              ),
              SizedBox(width: 8.w),
              IconButton(
                icon: const Icon(
                  CupertinoIcons.chat_bubble_2,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  // Handle messages action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
