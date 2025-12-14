import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/enums/notification_type.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/react_post_notification_item.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_state.dart';
import '../widgets/comment_notification_item.dart';
import '../widgets/friend_request_notification_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút';
    if (diff.inHours < 24) return '${diff.inHours} giờ';
    return '${diff.inDays} ngày';
  }

  Widget _buildNotificationItem(dynamic notification) {
    switch (notification.type) {
      case NotificationType.FRIEND_REQUEST:
        return FriendRequestNotificationItem(
          avatarUrl: notification.sender?.avatarUrl ?? '',
          userName: notification.sender?.fullName ?? '',
          time: _timeAgo(notification.createdAt),
          isRead: notification.isRead,
          mutualFriends: '',
          onAccept: () {},
          onRemove: () {},
        );

      case NotificationType.POST_COMMENT:
        return CommentNotificationItem(
          avatarUrl: notification.sender?.avatarUrl ?? '',
          userName: notification.sender?.fullName ?? '',
          content: notification.message,
          time: _timeAgo(notification.createdAt),
          isRead: notification.isRead,
        );
      case NotificationType.UNKNOWN:
        throw UnimplementedError();
      case NotificationType.POST_REACTION:
        return ReactPostNotificationItem(
          avatarUrl: notification.sender?.avatarUrl ?? '',
          userName: notification.sender?.fullName ?? '',
          message: notification.message,
          content: notification.content ?? 'like',
          time: _timeAgo(notification.createdAt),
          isRead: notification.isRead,
        );
      default:
        throw UnimplementedError(
          'Unknown notification type: ${notification.type}',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông báo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.notifications.isEmpty) {
            return const Center(child: Text('Chưa có thông báo'));
          }

          // Separate unread and read notifications
          final unreadNotifications = state.notifications
              .where((n) => !n.isRead)
              .toList();
          final readNotifications = state.notifications
              .where((n) => n.isRead)
              .toList();

          return ListView(
            children: [
              // "Mới" section (unread notifications)
              if (unreadNotifications.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Mới',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...unreadNotifications.map((n) => _buildNotificationItem(n)),
              ],
              // "Cũ hơn" section (read notifications)
              // Only show title if there are both unread and read notifications
              if (readNotifications.isNotEmpty &&
                  unreadNotifications.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Cũ hơn',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              // Show read notifications (with or without title)
              if (readNotifications.isNotEmpty)
                ...readNotifications.map((n) => _buildNotificationItem(n)),
            ],
          );
        },
      ),
    );
  }
}
