import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/enums/notification_type.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/react_post_notification_item.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/friend/domain/usecases/accept_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/reject_friend_request_usecase.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/notification/domain/usecases/delete_notification_usecase.dart';
import '../widgets/comment_notification_item.dart';
import '../widgets/friend_request_notification_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingPage = false;
  final int _pageSize = 10;
  VoidCallback? _scrollListener;
  @override
  void initState() {
    super.initState();
    // scroll listener will be added in build context
  }

  void _onScroll(bool hasMore, bool isLoadingMore, BuildContext context) {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore) {
      _loadNextPage(hasMore, context);
    }
  }

  void _loadNextPage(bool hasMore, BuildContext context) {
    if (!hasMore) {
      // no more data, don't load
      return;
    }

    _currentPage += 1;
    context.read<NotificationBloc>().add(
      LoadMoreNotificationsEvent(page: _currentPage, limit: _pageSize),
    );
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
          onAccept: () async {
            final targetId = notification.targetId;
            if (targetId == null) return;
            final result = await s1<AcceptFriendRequestUseCase>()(targetId);
            if (result is DataStateSuccess) {
              // also request server to delete notification from DB
              try {
                s1<DeleteNotificationUseCase>()(params: notification.id);
              } catch (_) {}
              context.read<NotificationBloc>().add(
                RemoveNotification(notification.id),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chấp nhận thất bại')),
              );
            }
          },
          onRemove: () async {
            final targetId = notification.targetId;
            if (targetId == null) return;
            final result = await s1<RejectFriendRequestUseCase>()(targetId);
            if (result is DataStateSuccess) {
              try {
                s1<DeleteNotificationUseCase>()(params: notification.id);
              } catch (_) {}
              context.read<NotificationBloc>().add(
                RemoveNotification(notification.id),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Xóa thất bại')));
            }
          },
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
          // Update scroll listener with current state flags
          if (_scrollListener != null) {
            _scrollController.removeListener(_scrollListener!);
          }
          _scrollListener = () =>
              _onScroll(state.hasMore, state.isLoadingMore, context);
          _scrollController.addListener(_scrollListener!);

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
            controller: _scrollController,
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

              // Loading indicator when loading more
              if (state.isLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),

              // Show "end of data" message when no more pages
              if (!state.hasMore && !state.isLoadingMore) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'Đã hiển thị hết thông báo',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_scrollListener != null) {
      _scrollController.removeListener(_scrollListener!);
    }
    _scrollController.dispose();
    super.dispose();
  }
}
