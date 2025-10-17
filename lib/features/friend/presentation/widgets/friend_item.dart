import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class FriendItem extends StatelessWidget {
  final String name;
  final int mutualFriends;
  final String? avatarUrl;
  final List<String>? mutualFriendAvatars;
  final VoidCallback? onMessage;
  final VoidCallback? onMoreOptions;

  const FriendItem({
    super.key,
    required this.name,
    required this.mutualFriends,
    this.avatarUrl,
    this.mutualFriendAvatars,
    this.onMessage,
    this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null
                    ? Icon(
                        CupertinoIcons.person_fill,
                        size: 30.r,
                        color: Colors.grey[400],
                      )
                    : null,
              ),
              // Online indicator
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 14.r,
                  height: 14.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2CD45C),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          // Name and mutual friends
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                // Chỉ hiển thị khi có bạn chung
                if (mutualFriends > 0)
                  Row(
                    children: [
                      // Hiển thị avatars bạn chung hoặc icon mặc định
                      if (mutualFriendAvatars != null && mutualFriendAvatars!.isNotEmpty)
                        _buildMutualFriendAvatars()
                      else
                        Container(
                          width: 16.r,
                          height: 16.r,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CupertinoIcons.person_2_fill,
                            size: 10.r,
                            color: Colors.grey[600],
                          ),
                        ),
                      SizedBox(width: 6.w),
                      Text(
                        '$mutualFriends bạn chung',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Action buttons
          Row(
            children: [
              // Message button
              GestureDetector(
                onTap: onMessage,
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.chat_bubble_fill,
                    size: 18.r,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // More options button
              GestureDetector(
                onTap: onMoreOptions,
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.more_horiz,
                    size: 20.r,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMutualFriendAvatars() {
    // Nếu không có avatars hoặc không có bạn chung, return empty widget
    if (mutualFriends == 0 || mutualFriendAvatars == null || mutualFriendAvatars!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 48.w,
      height: 20.h,
      child: Stack(
        children: List.generate(
          mutualFriendAvatars!.length.clamp(0, 3),
          (index) => Positioned(
            left: index * 16.w,
            child: Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(mutualFriendAvatars![index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

