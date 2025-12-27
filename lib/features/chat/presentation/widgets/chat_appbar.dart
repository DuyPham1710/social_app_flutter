import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/presentation/helper/chat_helper.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_info_page.dart';

class ChatAppbar extends StatefulWidget {
  final bool isGroup;
  final String? groupName;
  final String? groupAvatar;
  final List<UserEntity>? participants;
  final UserEntity? friendInfo;
  final String? conversationId;
  final String userId;
  final Function(String callType)? onInitiateCall;

  const ChatAppbar({
    super.key,
    required this.isGroup,
    this.groupName,
    this.groupAvatar,
    this.participants,
    this.friendInfo,
    required this.conversationId,
    required this.userId,
    this.onInitiateCall,
  });

  @override
  State<ChatAppbar> createState() => _ChatAppbarState();
}

class _ChatAppbarState extends State<ChatAppbar> {
  late String _displayName;

  @override
  void initState() {
    super.initState();
    _updateDisplayName();
  }

  void _updateDisplayName() {
    if (widget.isGroup) {
      _displayName = widget.groupName ?? 'Group Chat';
    } else {
      _displayName =
          widget.friendInfo?.fullName ??
          widget.friendInfo?.username ??
          "Unknown User";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy avatar hiển thị
    Widget avatarWidget = ChatHelper.buildAvatarWidget(
      isGroup: widget.isGroup,
      groupAvatar: widget.groupAvatar,
      participants: widget.participants,
      firstParticipant: widget.friendInfo,
      size: 36,
    );

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
              builder: (context) => ChatInfoPage(
                isGroup: widget.isGroup,
                displayName: _displayName,
                groupAvatar: widget.groupAvatar,
                participants: widget.participants,
                userInfo: widget.friendInfo,
                conversationId: widget.conversationId,
                userId: widget.userId,
                onInitiateCall: widget.onInitiateCall,
              ),
            ),
          ).then((newGroupName) {
            if (widget.isGroup &&
                newGroupName != null &&
                newGroupName is String &&
                newGroupName.isNotEmpty) {
              setState(() {
                _displayName = newGroupName;
              });
            }
          });
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
                    _displayName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.isGroup && widget.participants != null)
                    Text(
                      '${widget.participants!.length} thành viên',
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
          onPressed: () => widget.onInitiateCall?.call('audio'),
        ),
        IconButton(
          icon: Icon(
            CupertinoIcons.videocam_fill,
            color: AppColors.primary,
            size: 30.sp,
          ),
          onPressed: () => widget.onInitiateCall?.call('video'),
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
                builder: (context) => ChatInfoPage(
                  isGroup: widget.isGroup,
                  displayName: _displayName,
                  groupAvatar: widget.groupAvatar,
                  participants: widget.participants,
                  userInfo: widget.friendInfo,
                  conversationId: widget.conversationId,
                  userId: widget.userId,
                  onInitiateCall: widget.onInitiateCall,
                ),
              ),
            ).then((newGroupName) {
              if (widget.isGroup &&
                  newGroupName != null &&
                  newGroupName is String &&
                  newGroupName.isNotEmpty) {
                setState(() {
                  _displayName = newGroupName;
                });
              }
            });
          },
        ),
      ],
    );
  }
}
