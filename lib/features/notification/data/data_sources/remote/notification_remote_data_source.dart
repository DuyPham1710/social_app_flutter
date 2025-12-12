import 'dart:async';

import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/notification/data/models/notification_model.dart';

class NotificationRemoteDataSource {
  final SocketClient _socket;

  final _newNotificationController =
      StreamController<NotificationModel>.broadcast();

  final _unreadCountController = StreamController<int>.broadcast();

  final _notificationsLoadedController =
      StreamController<List<NotificationModel>>.broadcast();

  // Local cache
  List<NotificationModel> _notifications = [];

  NotificationRemoteDataSource(this._socket);

  Stream<NotificationModel> get newNotificationStream =>
      _newNotificationController.stream;

  Stream<int> get unreadCountStream => _unreadCountController.stream;

  Stream<List<NotificationModel>> get notificationsLoadedStream =>
      _notificationsLoadedController.stream;

  void connect(String userId) {
    _socket.connect(namespace: 'notification', userId: userId);
    _setupListeners();
  }

  void _setupListeners() {
    // Khi load toàn bộ notification
    _socket.on('notification:list').listen((data) {
      final list = (data as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();

      _notifications = list;
      _notificationsLoadedController.add(list);
    });

    // Khi có notification mới (WebSocket backend emit)
    _socket.on('notification:new').listen((data) {
      final model = NotificationModel.fromJson(data);
      _notifications.insert(0, model);

      _newNotificationController.add(model);
      _unreadCountController.add(
        _notifications.where((e) => !e.isRead).length,
      );
    });

    // Khi backend push unread count
    _socket.on('notification:unreadCount').listen((count) {
      _unreadCountController.add(count);
    });
  }

  void loadNotifications() {
    _socket.emit('notifications:load');
  }

  void markRead(String notificationId) {
    _socket.emit('notifications:markRead', {
      'notificationId': notificationId,
    });
  }

  void markAllRead() {
    _socket.emit('notifications:markAllRead');
  }

  void disconnect() {
    _socket.disconnect();
  }
}
