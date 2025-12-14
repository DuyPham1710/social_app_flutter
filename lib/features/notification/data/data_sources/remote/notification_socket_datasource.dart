import 'dart:async';
import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/notification/data/models/notification_model.dart';

class NotificationSocketDataSource {
  final SocketClient socket;

  final _listController = StreamController<List<NotificationModel>>.broadcast();
  final _newController = StreamController<NotificationModel>.broadcast();
  final _unreadController = StreamController<int>.broadcast();

  NotificationSocketDataSource(this.socket);

  Stream<List<NotificationModel>> get notifications => _listController.stream;
  Stream<NotificationModel> get newNotification => _newController.stream;
  Stream<int> get unreadCount => _unreadController.stream;

  void connect(String userId) {
    socket.connect(namespace: 'notification', userId: userId);

    socket.on('register:ack').listen((_) {
      socket.emit('getNotifications', {});
    });

    socket.on('notifications:list').listen((data) {
      final List<NotificationModel> items = [];

      for (final e in data['items']) {
        try {
          print('📦 Raw notification item: $e');
          items.add(NotificationModel.fromJson(Map<String, dynamic>.from(e)));
        } catch (err) {
          print('❌ Notification parse error: $err');
          print('❌ Raw item: $e');
        }
      }

      print('✅ Notifications received: ${items.length}');
      print('📋 Items content field: ${items.map((i) => i.content).toList()}');
      _listController.add(items);
      _unreadController.add(data['unread'] ?? 0);
    });

    socket.on('notification:new').listen((data) {
      final model = NotificationModel.fromJson(data);
      _newController.add(model);
    });

    socket.on('notification:read').listen((_) {
      socket.emit('getNotifications', {});
    });

    socket.on('notification:markAllRead').listen((_) {
      socket.emit('getNotifications', {});
    });
  }

  void markRead(String id) {
    socket.emit('markRead', {'notificationId': id});
  }

  void markAllRead() {
    socket.emit('markAllRead', {});
  }
}
