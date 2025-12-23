import 'dart:async';
import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/notification/data/models/notification_model.dart';

class NotificationSocketDataSource {
  final SocketClient socket;

  final _listController = StreamController<List<NotificationModel>>.broadcast();
  final _newController = StreamController<NotificationModel>.broadcast();
  final _unreadController = StreamController<int>.broadcast();

  NotificationSocketDataSource(this.socket);

  Stream<List<NotificationModel>> get notifications async* {
    // replay current cache to new subscribers
    yield List.unmodifiable(_cache);
    yield* _listController.stream;
  }

  Stream<NotificationModel> get newNotification => _newController.stream;

  Stream<int> get unreadCount async* {
    // replay current unread count to new subscribers
    yield _unreadCount;
    yield* _unreadController.stream;
  }

  // Internal cache to support pagination (append pages)
  final List<NotificationModel> _cache = [];
  int _lastRequestedPage = 1;
  bool _hasMore = true; // track if more pages available

  bool get hasMore => _hasMore;
  int _unreadCount = 0;
  final _hasMoreController = StreamController<bool>.broadcast();

  Stream<bool> get hasMoreStream async* {
    // replay current hasMore state to new subscribers
    yield _hasMore;
    yield* _hasMoreController.stream;
  }

  void connect(String userId) {
    socket.connect(namespace: 'notification', userId: userId);

    socket.on('register:ack').listen((_) {
      print(
        '[NotificationSocketDataSource] Socket registered, requesting first page',
      );
      // request first page on register
      loadPage(page: 1, limit: 10);
    });

    socket.on('notifications:list').listen((data) {
      print('[NotificationSocketDataSource] Received notifications:list event');
      final List<NotificationModel> items = [];
      // prefer explicit page from server; otherwise fall back to last requested
      final page = (data != null && data['page'] != null)
          ? (data['page'] is int
                ? data['page'] as int
                : int.tryParse(data['page'].toString()) ?? _lastRequestedPage)
          : _lastRequestedPage;

      for (final e in data['items']) {
        try {
          items.add(NotificationModel.fromJson(Map<String, dynamic>.from(e)));
        } catch (err) {
          print('Notification parse error: $err');
          print('Raw item: $e');
        }
      }

      print(
        '[NotificationSocketDataSource] Parsed ${items.length} notifications for page $page',
      );

      // Determine if more pages available: items < limit means no more data
      final limit = data['limit'] ?? 10;
      _hasMore = items.length >= limit;
      _hasMoreController.add(_hasMore);

      // Merge incoming items into cache by id to avoid losing previously loaded pages.
      final incomingIds = items.map((e) => e.id).toSet();

      if (page == 1) {
        final Map<String, NotificationModel> existingById = {
          for (var e in _cache) e.id: e,
        };

        final List<NotificationModel> merged = [];
        for (var it in items) {
          final existing = existingById[it.id];
          if (existing != null && existing.isRead && !it.isRead) {
            // Keep local isRead=true if we marked it as read locally
            merged.add(existing);
          } else {
            merged.add(it);
          }
        }
        // append older existing items that weren't in incoming
        for (var e in _cache) {
          if (!incomingIds.contains(e.id)) merged.add(e);
        }

        _cache
          ..clear()
          ..addAll(merged);
      } else {
        // For pages >1, append only new items (avoid duplicates)
        final existingIds = _cache.map((e) => e.id).toSet();
        for (var it in items) {
          if (!existingIds.contains(it.id)) _cache.add(it);
        }
      }

      print(
        '[NotificationSocketDataSource] Cache now has ${_cache.length} notifications',
      );
      _listController.add(List.unmodifiable(_cache));
      _unreadCount = data['unread'] ?? _unreadCount;
      _unreadController.add(_unreadCount);
      print('[NotificationSocketDataSource] Unread count: $_unreadCount');
    });

    socket.on('notification:new').listen((data) {
      final model = NotificationModel.fromJson(data);

      // Add to new stream
      _newController.add(model);

      final exists = _cache.any((c) => c.id == model.id);
      if (!exists) {
        _cache.insert(0, model);
      }

      _unreadCount = _unreadCount + 1;
      _listController.add(List.unmodifiable(_cache));
      _unreadController.add(_unreadCount);
    });
  }

  void markRead(String id) {
    final index = _cache.indexWhere((n) => n.id == id);
    if (index != -1) {
      final notification = _cache[index];
      _cache[index] = notification.copyWith(isRead: true);
      _listController.add(List.unmodifiable(_cache));

      _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
      _unreadController.add(_unreadCount);
    }

    socket.emit('markRead', {'notificationId': id});
  }

  void markAllRead() {
    for (int i = 0; i < _cache.length; i++) {
      if (!_cache[i].isRead) {
        _cache[i] = _cache[i].copyWith(isRead: true);
      }
    }

    _unreadCount = 0;

    _listController.add(List.unmodifiable(_cache));
    _unreadController.add(_unreadCount);

    socket.emit('markAllRead', {});
  }

  void loadPage({int page = 1, int limit = 10}) {
    _lastRequestedPage = page;
    socket.emit('getNotifications', {'page': page, 'limit': limit});
  }

  void deleteNotification(String id) {
    print(
      '[NotificationSocketDataSource] deleteNotification called for id: $id',
    );
    print(
      '[NotificationSocketDataSource] Cache before deletion: ${_cache.length} items',
    );

    // Remove from local cache immediately
    final removedCount = _cache.length;
    _cache.removeWhere((n) => n.id == id);
    print(
      '[NotificationSocketDataSource] Cache after deletion: ${_cache.length} items (removed: ${removedCount - _cache.length})',
    );

    // Update streams
    _listController.add(List.unmodifiable(_cache));

    // Recalculate unread count
    final unreadInCache = _cache.where((n) => !n.isRead).length;
    if (unreadInCache < _unreadCount) {
      _unreadCount = unreadInCache;
      _unreadController.add(_unreadCount);
    }

    // Notify server
    socket.emit('deleteNotification', {'notificationId': id});
    print(
      '[NotificationSocketDataSource] Delete notification emitted to server',
    );
  }

  /// Clear all notification cache (used when logging out)
  void clearCache() {
    print('[NotificationSocketDataSource] Clearing cache');
    _cache.clear();
    _unreadCount = 0;
    _lastRequestedPage = 1;
    _hasMore = true;

    // Reset streams to initial state
    _listController.add(List.unmodifiable(_cache));
    _unreadController.add(_unreadCount);
    _hasMoreController.add(_hasMore);

    print('[NotificationSocketDataSource] Cache cleared');
  }

  /// Disconnect socket and clear cache
  void dispose() {
    print('[NotificationSocketDataSource] Disposing');
    clearCache();
    socket.disconnect();
  }
}
