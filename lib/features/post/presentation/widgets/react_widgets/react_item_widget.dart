import 'package:flutter/material.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/post/presentation/widgets/react_widgets/react_action_button.dart';

class ReactItemWidget extends StatelessWidget {
  final ReactPostEntity react;
  final bool isSend;
  final String? requestId;
  final Function(String? parentId, String userDisplayName)? onMention;
  const ReactItemWidget({
    super.key,
    required this.react,
    required this.isSend,
    this.requestId,
    this.onMention,
  });

  @override
  Widget build(BuildContext context) {
    final bool showMutualFriends = (react.mutualFriendsCount ?? 0) > 0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          // Avatar với emoji
          Stack(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundImage: NetworkImage(
                  react.user.avatarUrl ??
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s',
                ),

                backgroundColor: AppColors.background,

                child: react.user.avatarUrl == null
                    ? Icon(
                        Icons.person,
                        color: AppColors.textSecondary,
                        size: 22.sp,
                      )
                    : null,
              ),

              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      react.emoji.icon,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 12.w),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: showMutualFriends
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Text(
                  react.user.fullName ?? react.user.username ?? 'Unknown',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (showMutualFriends) ...[
                  SizedBox(height: 2.h),
                  Text(
                    '${react.mutualFriendsCount} bạn chung',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Action button (Thêm bạn bè/Nhắc đến)
          if (showMutualFriends || react.isFriend == true) ...[
            SizedBox(width: 8.w),
            ReactActionButton(
              userId: react.user.userId,
              isFriend: react.isFriend,
              isSend: isSend,
              requestId: requestId,
              onMention: onMention,
              userDisplayName:
                  react.user.fullName ?? react.user.username ?? 'Unknown',
            ),
          ],
        ],
      ),
    );
  }
}
