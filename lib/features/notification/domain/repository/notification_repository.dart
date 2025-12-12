import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  void connect(String userId);

  Stream<NotificationEntity> get newNotificationStream;

  Stream<int> get unreadCountStream;

  Stream<List<NotificationEntity>> get notificationsLoadedStream;

  void loadNotifications();

  void markRead(String notificationId);

  void markAllRead();

  void disconnect();
}
