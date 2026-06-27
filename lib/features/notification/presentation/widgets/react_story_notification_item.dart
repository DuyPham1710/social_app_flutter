import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/comment/utils/comment_l10n_helper.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/notification_base_item.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ReactStoryNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String message;
  final String content;
  final String time;
  final bool isRead;
  final String? storyId;
  final VoidCallback? onUserTap;
  final VoidCallback? onMessageTap;
  final String actionText;

  const ReactStoryNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.userId,
    required this.content,
    required this.message,
    required this.time,
    required this.isRead,
    this.storyId,
    this.onUserTap,
    this.onMessageTap,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final EmojiType emoji = EmojiType.values.firstWhere(
      (e) => e.name == content,
      orElse: () => EmojiType.haha,
    );
    final String resolvedActionText = localizedReactionLabel(context.l10n, message);

    return NotificationBaseItem(
      isRead: isRead,
      avatarUrl: avatarUrl,
      userId: userId,
      onAvatarTap: onUserTap,
      onItemTap: onMessageTap,
      title: RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
          children: [
            TextSpan(
              text: userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = onUserTap,
            ),
            TextSpan(
              text: ' $actionText',
              recognizer: TapGestureRecognizer()..onTap = onMessageTap,
            ),
            TextSpan(
              text: ' $resolvedActionText',
              recognizer: TapGestureRecognizer()..onTap = onMessageTap,
            ),
          ],
        ),
      ),
      time: time,
      iconOverlay: CircleAvatar(
        radius: 12,
        backgroundColor: const Color.fromARGB(255, 196, 250, 241),
        child: Text(emoji.icon, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
