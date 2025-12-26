import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_info_page.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/group_avatar_widget.dart';

class ChatAppbar extends StatelessWidget {
  final bool isGroup;
  final String? groupName;
  final String? groupAvatar;
  final List<UserEntity>? participants;
  final UserEntity? friendInfo;
  final Function(String callType)? onInitiateCall;

  const ChatAppbar({
    super.key,
    required this.isGroup,
    this.groupName,
    this.groupAvatar,
    this.participants,
    this.friendInfo,
    this.onInitiateCall,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy tên và avatar hiển thị
    String displayName;
    String displayAvatar;
    Widget avatarWidget;

    if (isGroup) {
      // Group chat
      displayName = groupName ?? 'Group Chat';
      displayAvatar = groupAvatar ?? 'https://i.pravatar.cc/200';

      // Nếu group có nhiều participants và không có avatar custom, dùng GroupAvatarWidget
      if (participants != null && participants!.length > 1) {
        final avatarUrls = participants!
            .where((p) => p.avatarUrl != null && p.avatarUrl!.isNotEmpty)
            .map((p) => p.avatarUrl!)
            .toList();

        avatarWidget = GroupAvatarWidget(
          avatarUrls: avatarUrls.isNotEmpty ? avatarUrls : [displayAvatar],
          totalParticipants: participants!.length,
          size: 36,
        );
      } else {
        avatarWidget = CircleAvatar(
          backgroundImage: NetworkImage(displayAvatar),
          radius: 18.r,
        );
      }
    } else {
      // 1-1 chat
      displayName =
          friendInfo?.fullName ?? friendInfo?.username ?? "Unknown User";
      displayAvatar =
          friendInfo?.avatarUrl ??
          "https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg";

      avatarWidget = CircleAvatar(
        backgroundImage: NetworkImage(displayAvatar),
        radius: 18.r,
      );
    }

    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      shape: Border(
        bottom: BorderSide(
          color: AppColors.textSecondary.withOpacity(0.2),
          width: 1,
        ),
      ),
      leadingWidth: 40,
      leading: IconButton(
        icon: Icon(CupertinoIcons.back, color: AppColors.primary),
        onPressed: () => Navigator.pop(context),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ChatInfoPage(userInfo: friendInfo),
            ),
          );
        },
        child: Row(
          children: [
            avatarWidget,
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isGroup && participants != null)
                    Text(
                      '${participants!.length} thành viên',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                      ),
                    )
                  else
                    Text(
                      "Đang hoạt động",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            CupertinoIcons.phone_fill,
            color: AppColors.primary,
            size: 24.sp,
          ),
          onPressed: () => onInitiateCall?.call('audio'),
        ),
        IconButton(
          icon: Icon(
            CupertinoIcons.videocam_fill,
            color: AppColors.primary,
            size: 30.sp,
          ),
          onPressed: () => onInitiateCall?.call('video'),
        ),
        IconButton(
          icon: Icon(
            CupertinoIcons.info_circle_fill,
            color: AppColors.primary,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ChatInfoPage(userInfo: friendInfo),
              ),
            );
          },
        ),
      ],
    );
  }
}
