import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/presentation/pages/post_detail_page.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_action.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_header.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_classic.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_column.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_frame.dart';

class PostItem extends StatelessWidget {
  final PostEntity post;
  final int commentCount;

  const PostItem({super.key, required this.post, this.commentCount = 0});

  Widget _buildMediaLayout(BuildContext context, List<dynamic> urls) {
    late final Widget layout;

    void onImageTap(int initialIndex) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) =>
              PostDetailPage(post: post, initialImageIndex: initialIndex),
        ),
      );
    }

    switch (post.layout.toLowerCase()) {
      case 'classic':
        layout = LayoutPostClassic(urls: urls, onImageTap: onImageTap);
      case 'column':
        layout = LayoutPostColumn(urls: urls, onImageTap: onImageTap);
      case 'frame':
        layout = LayoutPostFrame(urls: urls, onImageTap: onImageTap);
      default:
        layout = LayoutPostClassic(urls: urls, onImageTap: onImageTap);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => PostDetailPage(post: post)),
        );
      },
      child: layout,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = post.user;
    final urls = post.urls;

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
          PostHeader(user: user, createdAt: post.createdAt),

          // Caption
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(post.caption, style: TextStyle(fontSize: 13.sp)),
          ),

          SizedBox(height: 8.h),

          // Media (images)
          if (urls.isNotEmpty)
            _buildMediaLayout(context, urls)
          else
            SizedBox.shrink(),

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

          PostAction(postId: post.id, commentCount: commentCount),
        ],
      ),
    );
  }
}
