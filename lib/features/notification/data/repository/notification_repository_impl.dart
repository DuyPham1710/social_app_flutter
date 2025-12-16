import 'package:social_app_fe/features/notification/data/data_sources/remote/notification_socket_datasource.dart';
import 'package:social_app_fe/features/notification/data/models/notification_model.dart';
import 'package:social_app_fe/features/notification/domain/repository/notification_repository.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationSocketDataSource datasource;

  NotificationRepositoryImpl(this.datasource);

  @override
  void connect(String userId) => datasource.connect(userId);

  @override
  Stream<List<NotificationEntity>> get notifications => datasource.notifications
      .map((list) => list.map((e) => e.toEntity()).toList());

  @override
  Stream<NotificationEntity> get newNotification =>
      datasource.newNotification.map((e) => e.toEntity());

  @override
  Stream<int> get unreadCount => datasource.unreadCount;

  @override
  Stream<bool> get hasMore => datasource.hasMoreStream;

  @override
  void markRead(String notificationId) => datasource.markRead(notificationId);

  @override
  void markAllRead() => datasource.markAllRead();

  @override
  void loadPage({int page = 1, int limit = 10}) =>
      datasource.loadPage(page: page, limit: limit);

  @override
  void deleteNotification(String notificationId) =>
      datasource.deleteNotification(notificationId);
}
