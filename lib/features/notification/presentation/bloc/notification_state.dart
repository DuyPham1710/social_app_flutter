import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';

class NotificationState {
  final List<NotificationEntity> notifications;
  final int unread;

  const NotificationState({
    required this.notifications,
    required this.unread,
  });

  factory NotificationState.initial() =>
      const NotificationState(notifications: [], unread: 0);
}
