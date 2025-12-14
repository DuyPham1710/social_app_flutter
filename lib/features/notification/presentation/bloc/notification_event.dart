import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationEvent {}

class ConnectNotificationSocket extends NotificationEvent {
  final String userId;
  ConnectNotificationSocket(this.userId);
}

class NotificationsLoaded extends NotificationEvent {
  final List<NotificationEntity> notifications;
  NotificationsLoaded(this.notifications);
}

class NewNotificationReceived extends NotificationEvent {
  final NotificationEntity notification;
  NewNotificationReceived(this.notification);
}


class UnreadCountUpdated extends NotificationEvent {
  final int unread;
  UnreadCountUpdated(this.unread);
}

class MarkNotificationRead extends NotificationEvent {
  final String id;
  MarkNotificationRead(this.id);
}

class MarkAllNotificationsRead extends NotificationEvent {}
