import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';

class NotificationState {
  final List<NotificationEntity> notifications;
  final int unread;
  final bool hasMore; // track if more pages available
  final bool isLoadingMore; // track if currently loading more pages

  const NotificationState({
    required this.notifications,
    required this.unread,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  factory NotificationState.initial() => const NotificationState(
    notifications: [],
    unread: 0,
    hasMore: true,
    isLoadingMore: false,
  );
}
