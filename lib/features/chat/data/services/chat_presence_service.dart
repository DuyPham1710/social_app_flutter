import 'dart:async';
import 'dart:developer' as developer;

import 'package:social_app_fe/core/network/websocket/socket_client.dart';

class ChatPresenceStatus {
  final bool isOnline;
  final DateTime? lastSeenAt;

  const ChatPresenceStatus({
    required this.isOnline,
    this.lastSeenAt,
  });
}

class ChatPresenceService {
  final SocketClient _socketClient;

  bool _isConnected = false;
  final Map<String, ChatPresenceStatus> _presenceByUserId = {};

  final StreamController<Map<String, ChatPresenceStatus>> _presenceController =
      StreamController<Map<String, ChatPresenceStatus>>.broadcast();

  Stream<Map<String, ChatPresenceStatus>> get presenceStream =>
      _presenceController.stream;

  Map<String, ChatPresenceStatus> get presenceSnapshot =>
      Map.unmodifiable(_presenceByUserId);

  ChatPresenceService(this._socketClient);

  void connect({
    required String userId,
    required String username,
  }) {
    if (_isConnected && _socketClient.isConnected) return;

    _socketClient.connect(
      namespace: 'chat',
      userId: userId,
      username: username,
    );

    _setupListeners();

    // Nếu socket đã connected từ trước (singleton chatSocket), server sẽ không emit lại event 'connected'.
    // Trong trường hợp đó, coi như đã sẵn sàng để emit presence:get ngay.
    _isConnected = _socketClient.isConnected;
  }

  void _setupListeners() {
    _socketClient.on('connected').listen((_) {
      _isConnected = true;
      developer.log('ChatPresenceService connected', name: 'ChatPresenceService');
    });

    _socketClient.on('presence:list').listen((data) {
      try {
        if (data is Map && data['users'] is List) {
          final users = data['users'] as List;
          for (final u in users) {
            if (u is! Map) continue;
            final userId = u['userId']?.toString() ?? '';
            if (userId.isEmpty) continue;

            final isOnline = (u['isOnline'] as bool?) ?? false;
            DateTime? lastSeenAt;
            final raw = u['lastSeenAt'];
            if (raw is String) {
              lastSeenAt = DateTime.tryParse(raw);
            } else if (raw is num) {
              lastSeenAt = DateTime.fromMillisecondsSinceEpoch(raw.toInt());
            } else if (raw is DateTime) {
              lastSeenAt = raw;
            }

            _presenceByUserId[userId] = ChatPresenceStatus(
              isOnline: isOnline,
              lastSeenAt: lastSeenAt,
            );
          }
          _presenceController.add(Map.unmodifiable(_presenceByUserId));
        }
      } catch (e) {
        developer.log('Error parsing presence:list: $e', name: 'ChatPresenceService');
      }
    });

    _socketClient.on('presence:online').listen((data) {
      try {
        final userId = data is Map ? data['userId']?.toString() ?? '' : '';
        if (userId.isEmpty) return;

        _presenceByUserId[userId] = const ChatPresenceStatus(
          isOnline: true,
          lastSeenAt: null,
        );
        _presenceController.add(Map.unmodifiable(_presenceByUserId));
      } catch (e) {
        developer.log('Error parsing presence:online: $e', name: 'ChatPresenceService');
      }
    });

    _socketClient.on('presence:offline').listen((data) {
      try {
        final userId = data is Map ? data['userId']?.toString() ?? '' : '';
        if (userId.isEmpty) return;

        DateTime? lastSeenAt;
        final raw = data is Map ? data['lastSeenAt'] : null;
        if (raw is String) {
          lastSeenAt = DateTime.tryParse(raw);
        } else if (raw is num) {
          lastSeenAt = DateTime.fromMillisecondsSinceEpoch(raw.toInt());
        } else if (raw is DateTime) {
          lastSeenAt = raw;
        }

        _presenceByUserId[userId] = ChatPresenceStatus(
          isOnline: false,
          lastSeenAt: lastSeenAt ?? DateTime.now(),
        );
        _presenceController.add(Map.unmodifiable(_presenceByUserId));
      } catch (e) {
        developer.log('Error parsing presence:offline: $e', name: 'ChatPresenceService');
      }
    });

    _socketClient.on('disconnect').listen((_) {
      _isConnected = false;
    });
  }

  void requestPresence(List<String> userIds) {
    if (!_socketClient.isConnected) return;
    _socketClient.emit('presence:get', {'userIds': userIds});
  }

  ChatPresenceStatus? getUserPresence(String userId) => _presenceByUserId[userId];

  void dispose() {
    _isConnected = false;
    _presenceByUserId.clear();
    _presenceController.close();
  }
}

