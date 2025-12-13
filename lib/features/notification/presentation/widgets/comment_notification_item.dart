import 'package:flutter/material.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/notification_base_item.dart';

class CommentNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String content;
  final String time;
  final bool isRead;

  const CommentNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.content,
    required this.time,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationBaseItem(
      isRead: isRead,
      avatarUrl: avatarUrl,
      title: RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ' $content',
            ),
          ],
        ),
      ),
      preview: null, // content đã nằm trong title
      time: time,
      iconOverlay: const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.chat_bubble,
          color: Colors.white,
          size: 14,
        ),
      ),
    );
  }
}
