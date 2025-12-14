import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  void connect(String userId);

  Stream<List<NotificationEntity>> get notifications;
  Stream<NotificationEntity> get newNotification;
  Stream<int> get unreadCount;

  void markRead(String notificationId);
  void markAllRead();
}

