import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/group_avatar_widget.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ConversationItem extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String preview;
  final bool isUnread;
  final bool isGroup;
  final List<UserEntity>? participants;
  final bool? isOnline;
  final VoidCallback onTap;

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
  });

  @override
  Widget build(BuildContext context) {
    // Build avatar widget
    Widget avatarWidget;
    if (isGroup && participants != null && participants!.length > 1) {
      // Group chat với nhiều participants
      final avatarUrls = participants!
          .where((p) => p.avatarUrl != null && p.avatarUrl!.isNotEmpty)
          .map((p) => p.avatarUrl!)
          .toList();

      avatarWidget = GroupAvatarWidget(
        avatarUrls: avatarUrls.isNotEmpty
            ? avatarUrls
            : ['https://i.pravatar.cc/200'],
        totalParticipants: participants!.length,
        size: 52,
      );
    } else {
      // Single avatar (1-1 chat or group with custom avatar)
      avatarWidget = CircleAvatar(
        radius: 26.r,
        backgroundImage: NetworkImage(avatarUrl ?? 'https://i.pravatar.cc/200'),
        backgroundColor: AppColors.textSecondary.withOpacity(0.1),
      );
    }

    final avatarWithStatus = (!isGroup && isOnline == true)
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

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
      leading: avatarWithStatus,
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        preview.contains('null') ? context.l10n.chatConnected : preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isUnread ? AppColors.textPrimary : AppColors.textSecondary,
          fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
        ),
      ),

      // Chỉ hiện chấm xanh nếu chưa đọc
      trailing: isUnread
          ? Icon(Icons.circle, color: AppColors.primary, size: 10.r)
          : null,

      onTap: onTap,
    );
  }
}
