import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostItem extends StatelessWidget {
  final PostEntity post;
  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final user = post.user;
    final urls = post.urls;
    final firstImageUrl = urls.isNotEmpty
        ? urls.first.url
        : "https://via.placeholder.com/300";

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
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    user.avatarUrl ??
                        "https://randomuser.me/api/portraits/men/1.jpg",
                  ),
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName ?? "Unknown",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        post.createdAt != null
                            ? timeago.format(post.createdAt!)
                            : "Unknown date",
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
            child: Text(post.caption, style: TextStyle(fontSize: 13.sp)),
          ),

          SizedBox(height: 8.h),

          // Media (image/video)
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  firstImageUrl,
                  //    "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
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
