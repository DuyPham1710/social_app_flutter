import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/notification_base_item.dart';

class TagNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userId;
  final String message;
  final String time;
  final bool isRead;
  final String? postId;
  final VoidCallback? onUserTap;
  final VoidCallback? onMessageTap;
  final String actionText;

  const TagNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.userId,
    required this.message,
    required this.time,
    required this.isRead,
    this.postId,
    this.onUserTap,
    this.onMessageTap,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationBaseItem(
      isRead: isRead,
      avatarUrl: avatarUrl,
      userId: userId,
      onAvatarTap: onUserTap,
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
          ],
        ),
      ),
      time: time,
      iconOverlay: const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.green,
        child: Icon(Icons.local_offer, color: Colors.white, size: 14),
      ),
    );
  }
}
