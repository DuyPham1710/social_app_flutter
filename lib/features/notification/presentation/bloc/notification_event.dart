import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationEvent {}

class ConnectNotificationSocket extends NotificationEvent {
  final String userId;
  ConnectNotificationSocket(this.userId);
}

class DisconnectNotificationSocket extends NotificationEvent {}

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

class RemoveNotification extends NotificationEvent {
  final String id;
  RemoveNotification(this.id);
}

class LoadMoreNotificationsEvent extends NotificationEvent {
  final int page;
  final int limit;

  LoadMoreNotificationsEvent({this.page = 1, this.limit = 10});
}

class HasMoreUpdated extends NotificationEvent {
  final bool hasMore;
  HasMoreUpdated(this.hasMore);
}

class ClearNotificationCache extends NotificationEvent {}

class ReloadNotifications extends NotificationEvent {}
