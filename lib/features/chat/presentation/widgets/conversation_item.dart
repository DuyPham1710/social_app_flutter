import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/group_avatar_widget.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class ConversationItem extends StatefulWidget {
  final String? avatarUrl;
  final String name;
  final String preview;
  final bool isUnread;
  final bool isGroup;
  final List<UserEntity>? participants;
  final bool? isOnline;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDelete;
  final VoidCallback? onPin;

  const ConversationItem({
    super.key,
    this.avatarUrl,
    required this.name,
    required this.preview,
    required this.isUnread,
    required this.isGroup,
    this.participants,
    this.isOnline,
    required this.onTap,
    this.onLongPress,
    this.onDelete,
    this.onPin,
  });

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    // Build avatar widget
    Widget avatarWidget;
    if (widget.isGroup &&
        widget.participants != null &&
        widget.participants!.length > 1) {
      // Group chat với nhiều participants
      final avatarUrls = widget.participants!
          .where((p) => p.avatarUrl != null && p.avatarUrl!.isNotEmpty)
          .map((p) => p.avatarUrl!)
          .toList();

      avatarWidget = GroupAvatarWidget(
        avatarUrls: avatarUrls.isNotEmpty
            ? avatarUrls
            : ['https://i.pravatar.cc/200'],
        totalParticipants: widget.participants!.length,
        size: 52,
      );
    } else {
      // Single avatar (1-1 chat or group with custom avatar)
      avatarWidget = CircleAvatar(
        radius: 26.r,
        backgroundImage: NetworkImage(
          widget.avatarUrl ?? 'https://i.pravatar.cc/200',
        ),
        backgroundColor: AppColors.textSecondary.withOpacity(0.1),
      );
    }

    final avatarWithStatus = (!widget.isGroup && widget.isOnline == true)
        ? Stack(
            children: [
              avatarWidget,
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 14.r,
                  height: 14.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2CD45C),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          )
        : avatarWidget;

    Widget? trailingWidget;
    if (ResponsiveHelper.isWebOrDesktop && _isHovering) {
      trailingWidget = IconButton(
        icon: Icon(Icons.more_horiz, color: AppColors.textSecondary),
        onPressed: widget.onLongPress,
      );
    } else if (widget.isUnread) {
      trailingWidget = Icon(Icons.circle, color: AppColors.primary, size: 10.r);
    }

    final listTile = ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
      leading: avatarWithStatus,
      title: Text(
        widget.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        widget.preview.contains('null')
            ? context.l10n.chatConnected
            : widget.preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: widget.isUnread
              ? AppColors.textPrimary
              : AppColors.textSecondary,
          fontWeight: widget.isUnread ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: trailingWidget,
      onTap: widget.onTap,
      onLongPress: ResponsiveHelper.isWebOrDesktop ? null : widget.onLongPress,
    );

    if (ResponsiveHelper.isWebOrDesktop) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: listTile,
      );
    }

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => widget.onPin?.call(),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: CupertinoIcons.pin_fill,
            label: context.l10n.chatPin,
          ),
          SlidableAction(
            onPressed: (_) => widget.onDelete?.call(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: CupertinoIcons.delete_solid,
            label: context.l10n.chatDeleteConversation,
          ),
        ],
      ),
      child: listTile,
    );
  }
}
