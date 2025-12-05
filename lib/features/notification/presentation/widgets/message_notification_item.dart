import 'package:flutter/material.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/notification_base_item.dart';

class MessageNotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String title;
  final String time;
  final bool isRead;

  const MessageNotificationItem({
    super.key,
    required this.avatarUrl,
    required this.title,
    required this.time,
    required this.isRead
  });

  @override
  Widget build(BuildContext context) {
    return NotificationBaseItem(
      isRead: isRead,
      avatarUrl: avatarUrl,
      title: title,
      time: time,
      iconOverlay: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.message, color: Colors.white, size: 14),
      ),
    );
  }
}
