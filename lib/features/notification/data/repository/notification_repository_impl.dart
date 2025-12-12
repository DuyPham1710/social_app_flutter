import 'package:social_app_fe/features/notification/data/data_sources/remote/notification_remote_data_source.dart';
import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';
import 'package:social_app_fe/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remote;

  NotificationRepositoryImpl(this._remote);

  @override
  void connect(String userId) {
    _remote.connect(userId);
  }

  @override
  Stream<NotificationEntity> get newNotificationStream =>
      _remote.newNotificationStream;

  @override
  Stream<int> get unreadCountStream => _remote.unreadCountStream;

  @override
  Stream<List<NotificationEntity>> get notificationsLoadedStream =>
      _remote.notificationsLoadedStream;

  @override
  void loadNotifications() {
    _remote.loadNotifications();
  }

  @override
  void markRead(String notificationId) {
    _remote.markRead(notificationId);
  }

  @override
  void markAllRead() {
    _remote.markAllRead();
  }

  @override
  void disconnect() {
    _remote.disconnect();
  }
}
