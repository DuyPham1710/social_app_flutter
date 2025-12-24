import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  void connect(String userId);
  void disconnect();

  Stream<List<NotificationEntity>> get notifications;
  Stream<NotificationEntity> get newNotification;
  Stream<int> get unreadCount;
  Stream<bool> get hasMore;

  void markRead(String notificationId);
  void markAllRead();
  void loadPage({int page = 1, int limit = 10});
  void deleteNotification(String notificationId);
  void clearCache();
  void dispose();
}
