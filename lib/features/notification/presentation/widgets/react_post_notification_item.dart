import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/notification_base_item.dart';

class ReactPostNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String message;
  final String content;
  final String time;
  final bool isRead;
  final String? postId;
  final VoidCallback? onUserTap;
  final VoidCallback? onMessageTap;

  const ReactPostNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.userId,
    required this.content,
    required this.message,
    required this.time,
    required this.isRead,
    this.postId,
    this.onUserTap,
    this.onMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    final EmojiType emoji = EmojiType.values.firstWhere(
      (e) => e.name == content,
      orElse: () => EmojiType.haha,
    );

    return NotificationBaseItem(
      isRead: isRead,
      avatarUrl: avatarUrl,
      userId: userId,
      onAvatarTap: onUserTap,
      title: RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black),
          children: [
            TextSpan(
              text: userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = onUserTap,
            ),
            TextSpan(
              text: ' $message',
              recognizer: TapGestureRecognizer()..onTap = onMessageTap,
            ),
          ],
        ),
      ),
      time: time,
      iconOverlay: CircleAvatar(
        radius: 12,
        backgroundColor: const Color.fromARGB(255, 205, 206, 205),
        child: Text(emoji.icon, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
