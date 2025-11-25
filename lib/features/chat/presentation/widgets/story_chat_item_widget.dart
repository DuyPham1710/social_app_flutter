import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class StoryChatItemWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool showAddButton;
  final VoidCallback? onTap;

  const StoryChatItemWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    this.showAddButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(imageUrl)),

              // hiện khi item đó là item đầu tiên (thêm story mới)
              if (showAddButton)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.add, size: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            name,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
