import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/enums/notification_type.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/react_post_notification_item.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_state.dart';
import '../widgets/comment_notification_item.dart';
import '../widgets/friend_request_notification_item.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút';
    if (diff.inHours < 24) return '${diff.inHours} giờ';
    return '${diff.inDays} ngày';
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

          return ListView(
            children: state.notifications.map((n) {
              switch (n.type) {
                case NotificationType.FRIEND_REQUEST:
                  return FriendRequestNotificationItem(
                    avatarUrl: n.sender?.avatarUrl ?? '',
                    userName: n.sender?.fullName ?? '',
                    time: _timeAgo(n.createdAt),
                    isRead: n.isRead,
                    mutualFriends: '',
                    onAccept: () {},
                    onRemove: () {},
                  );

                case NotificationType.POST_COMMENT:
                  return CommentNotificationItem(
                    avatarUrl: n.sender?.avatarUrl ?? '',
                    userName: n.sender?.fullName ?? '',
                    content: n.message,
                    time: _timeAgo(n.createdAt),
                    isRead: n.isRead,
                  );
                case NotificationType.UNKNOWN:
                  // TODO: Handle this case.
                  throw UnimplementedError();
                case NotificationType.POST_REACTION:
                  return ReactPostNotificationItem(
                    avatarUrl: n.sender?.avatarUrl ?? '',
                    userName: n.sender?.fullName ?? '',
                    message: n.message,
                    content: n.content ?? '',
                    time: _timeAgo(n.createdAt),
                    isRead: n.isRead,
                  );
              }
            }).toList(),
          );
        },
      ),
    );
  }
}
