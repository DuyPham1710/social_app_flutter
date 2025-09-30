import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.r),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/1.jpg",
                  ),
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Duy Pham",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "1h ago",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.share, size: 20.sp),
              ],
            ),
          ),

          // Caption
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              "Trời hôm nay nóng ghê, cũng may là có sự lạnh lùng của em :))",
              style: TextStyle(fontSize: 13.sp),
            ),
          ),

          SizedBox(height: 8.h),

          // Media (image/video)
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
                  width: double.infinity,
                  height: 220.h,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    Icons.play_arrow,
                    size: 36.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // Likes info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: const [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/men/2.jpg",
                      ),
                    ),
                    Positioned(
                      left: 18,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(
                          "https://randomuser.me/api/portraits/women/2.jpg",
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 30.w),

                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Liked by ",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        TextSpan(
                          text: "Lam ",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "and 100+ others",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Actions row (like, comment)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 24.sp),
                SizedBox(width: 4.w),
                Text("144", style: TextStyle(fontSize: 12.sp)),
                SizedBox(width: 16.w),
                Icon(
                  CupertinoIcons.chat_bubble,
                  color: Colors.black87,
                  size: 20.sp,
                ),
                SizedBox(width: 4.w),
                Text("57", style: TextStyle(fontSize: 12.sp)),
              ],
            ),
          ),

          SizedBox(height: 6.h),

          // View comments
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              "View all 57 comments",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
