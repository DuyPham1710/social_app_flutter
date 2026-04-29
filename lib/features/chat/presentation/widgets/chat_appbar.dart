import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/data/services/chat_presence_service.dart';
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
  final String username;
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
    required this.username,
    this.onInitiateCall,
  });

  @override
  State<ChatAppbar> createState() => _ChatAppbarState();
}

class _ChatAppbarState extends State<ChatAppbar> {
  late String _displayName;
  SocketClient? _presenceSocketClient;
  ChatPresenceService? _presenceService;
  StreamSubscription<Map<String, ChatPresenceStatus>>? _presenceSub;
  ChatPresenceStatus? _friendPresence;
  Timer? _relativeTimeTimer;

  @override
  void initState() {
    super.initState();
    _updateDisplayName();
    _initPresence();
  }

  void _initPresence() {
    if (widget.isGroup) return;
    final friendId = widget.friendInfo?.userId;
    if (friendId == null || friendId.isEmpty) return;

    _presenceSocketClient ??= s1<SocketClient>(instanceName: 'chatSocket');
    _presenceService ??= ChatPresenceService(_presenceSocketClient!);
    _presenceService!.connect(userId: widget.userId, username: widget.username);

    _presenceSub?.cancel();
    _presenceSub = _presenceService!.presenceStream.listen((map) {
      final status = map[friendId];
      if (!mounted) return;
      setState(() {
        _friendPresence = status;
      });
      _syncRelativeTimer();
    });

    _presenceService!.requestPresence([friendId]);
  }

  void _syncRelativeTimer() {
    final status = _friendPresence;
    final shouldTick =
        status != null && status.isOnline == false && status.lastSeenAt != null;

    if (!shouldTick) {
      _relativeTimeTimer?.cancel();
      _relativeTimeTimer = null;
      return;
    }

    if (_relativeTimeTimer != null) return;

    // Tick để text "Hoạt động X phút trước" tự tăng
    _relativeTimeTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  String _formatPresenceText(ChatPresenceStatus status) {
    if (status.isOnline) return 'Online';
    final lastSeenAt = status.lastSeenAt?.toLocal();
    if (lastSeenAt == null) return 'Offline';

    final diff = DateTime.now().difference(lastSeenAt);
    if (diff.inMinutes < 1) return 'Vừa hoạt động';
    if (diff.inMinutes < 60) return 'Hoạt động ${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return 'Hoạt động ${diff.inHours} giờ trước';
    return 'Hoạt động ${diff.inDays} ngày trước';
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
  void dispose() {
    _presenceSub?.cancel();
    _presenceService?.dispose();
    _relativeTimeTimer?.cancel();
    super.dispose();
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
                      _friendPresence == null
                          ? "Đang hoạt động"
                          : _formatPresenceText(_friendPresence!),
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
