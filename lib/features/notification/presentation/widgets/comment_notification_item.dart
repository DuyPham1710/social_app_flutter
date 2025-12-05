import 'package:flutter/material.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/notification_base_item.dart';

class CommentNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String title;
  final String preview;
  final String time;
  final bool isRead;

  const CommentNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.title,
    required this.preview,
    required this.time,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationBaseItem(
      isRead: isRead, // màu nền khi chưa đọc
      avatarUrl: avatarUrl,
      title: title,
      preview: preview,
      time: time,
      iconOverlay: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.green,
        child: const Icon(Icons.chat_bubble, color: Colors.white, size: 14),
      ),
    );
  }
}
