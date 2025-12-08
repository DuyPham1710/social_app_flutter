import 'dart:async';
import 'dart:developer' as developer;

import 'package:social_app_fe/core/network/websocket/socket_client.dart';

/// Model để lưu trạng thái online của một bạn bè
class FriendOnlineStatus {
  final bool isOnline;
  final DateTime? lastSeen;

  FriendOnlineStatus({
    required this.isOnline,
    this.lastSeen,
  });
}

/// Service quản lý trạng thái online của bạn bè qua WebSocket
class FriendOnlineService {
  final SocketClient _socketClient;
  final StreamController<int> _onlineCountController =
      StreamController<int>.broadcast();
  final StreamController<Map<String, FriendOnlineStatus>> _friendsStatusController =
      StreamController<Map<String, FriendOnlineStatus>>.broadcast();

  int _onlineCount = 0;
  bool _isConnected = false;
  
  // Map để lưu trạng thái online của từng bạn bè: userId -> FriendOnlineStatus
  final Map<String, FriendOnlineStatus> _friendsStatus = {};

  FriendOnlineService(this._socketClient);

  /// Stream số lượng bạn bè đang online
  Stream<int> get onlineCountStream => _onlineCountController.stream;

  /// Stream trạng thái online của tất cả bạn bè
  Stream<Map<String, FriendOnlineStatus>> get friendsStatusStream =>
      _friendsStatusController.stream;

  /// Số lượng bạn bè đang online hiện tại
  int get onlineCount => _onlineCount;

  /// Trạng thái kết nối
  bool get isConnected => _isConnected;

  /// Lấy trạng thái online của một bạn bè
  FriendOnlineStatus? getFriendStatus(String userId) {
    return _friendsStatus[userId];
  }

  /// Lấy tất cả trạng thái bạn bè
  Map<String, FriendOnlineStatus> get allFriendsStatus => Map.unmodifiable(_friendsStatus);

  /// Kết nối đến friend namespace và lắng nghe events
  void connect(String userId, String username) {
    if (_isConnected && _socketClient.isConnected) {
      developer.log(
        'Friend online service already connected',
        name: 'FriendOnlineService',
      );
      return;
    }

    _socketClient.connect(
      namespace: 'friend',
      userId: userId,
      username: username,
    );

    _setupListeners();
  }

  /// Thiết lập các listeners cho WebSocket events
  void _setupListeners() {
    // Lắng nghe khi kết nối thành công
    _socketClient.on('connected').listen((data) {
      developer.log('Friend online service connected', name: 'FriendOnlineService');
      _isConnected = true;
      
      // Yêu cầu số lượng bạn bè online khi kết nối
      _requestOnlineCount();
    });

    // Lắng nghe event trả về số lượng bạn bè online
    _socketClient.on('onlineFriendsCount').listen((data) {
      try {
        final count = data is Map ? (data['count'] as num?)?.toInt() ?? 0 : 0;
        _updateOnlineCount(count);
        developer.log(
          'Received online friends count: $count',
          name: 'FriendOnlineService',
        );
      } catch (e) {
        developer.log(
          'Error parsing onlineFriendsCount: $e',
          name: 'FriendOnlineService',
        );
      }
    });

    // Lắng nghe event trả về danh sách bạn bè đang online
    _socketClient.on('onlineFriendsList').listen((data) {
      try {
        if (data is Map && data['friends'] is List) {
          final friends = data['friends'] as List;
          final now = DateTime.now();
          
          for (final friend in friends) {
            if (friend is Map) {
              final userId = friend['userId']?.toString() ?? '';
              if (userId.isNotEmpty) {
                // Parse lastSeen từ timestamp hoặc string
                DateTime? lastSeen;
                if (friend['lastSeen'] != null) {
                  if (friend['lastSeen'] is DateTime) {
                    lastSeen = friend['lastSeen'] as DateTime;
                  } else if (friend['lastSeen'] is String) {
                    lastSeen = DateTime.tryParse(friend['lastSeen'] as String);
                  } else if (friend['lastSeen'] is num) {
                    lastSeen = DateTime.fromMillisecondsSinceEpoch(
                      (friend['lastSeen'] as num).toInt(),
                    );
                  }
                }
                
                _friendsStatus[userId] = FriendOnlineStatus(
                  isOnline: true,
                  lastSeen: lastSeen ?? now,
                );
              }
            }
          }
          
          // Emit update
          _friendsStatusController.add(Map.unmodifiable(_friendsStatus));
          
          developer.log(
            'Received online friends list: ${friends.length} friends',
            name: 'FriendOnlineService',
          );
        }
      } catch (e) {
        developer.log(
          'Error parsing onlineFriendsList: $e',
          name: 'FriendOnlineService',
        );
      }
    });

    // Lắng nghe khi có bạn bè online
    _socketClient.on('friendOnline').listen((data) {
      try {
        final userId = data is Map ? (data['userId'] as String?) ?? '' : '';
        final username = data is Map ? (data['username'] as String?) : null;
        
        if (userId.isNotEmpty) {
          developer.log(
            'Friend came online: $userId ($username)',
            name: 'FriendOnlineService',
          );
          
          // Kiểm tra trạng thái trước đó
          final currentStatus = _friendsStatus[userId];
          final wasOffline = currentStatus == null || currentStatus.isOnline == false;
          
          // Cập nhật trạng thái
          _friendsStatus[userId] = FriendOnlineStatus(
            isOnline: true,
            lastSeen: DateTime.now(),
          );
          
          // Emit update
          _friendsStatusController.add(Map.unmodifiable(_friendsStatus));
          
          // Cập nhật số lượng online
          if (wasOffline) {
            _updateOnlineCount(_onlineCount + 1);
          }
        }
      } catch (e) {
        developer.log(
          'Error parsing friendOnline: $e',
          name: 'FriendOnlineService',
        );
      }
    });

    // Lắng nghe khi có bạn bè offline
    _socketClient.on('friendOffline').listen((data) {
      try {
        final userId = data is Map ? (data['userId'] as String?) ?? '' : '';
        
        if (userId.isNotEmpty) {
          developer.log(
            'Friend went offline: $userId',
            name: 'FriendOnlineService',
          );
          
          // Parse lastSeen từ event
          DateTime? lastSeen;
          if (data is Map && data['lastSeen'] != null) {
            if (data['lastSeen'] is DateTime) {
              lastSeen = data['lastSeen'] as DateTime;
            } else if (data['lastSeen'] is String) {
              lastSeen = DateTime.tryParse(data['lastSeen'] as String);
            } else if (data['lastSeen'] is num) {
              lastSeen = DateTime.fromMillisecondsSinceEpoch(
                (data['lastSeen'] as num).toInt(),
              );
            }
          }
          
          // Cập nhật trạng thái
          final currentStatus = _friendsStatus[userId];
          _friendsStatus[userId] = FriendOnlineStatus(
            isOnline: false,
            lastSeen: lastSeen ?? currentStatus?.lastSeen ?? DateTime.now(),
          );
          
          // Emit update
          _friendsStatusController.add(Map.unmodifiable(_friendsStatus));
          
          // Cập nhật số lượng online
          final wasOnline = currentStatus?.isOnline == true;
          if (wasOnline && _onlineCount > 0) {
            _updateOnlineCount(_onlineCount - 1);
          }
        }
      } catch (e) {
        developer.log(
          'Error parsing friendOffline: $e',
          name: 'FriendOnlineService',
        );
      }
    });

    // Lắng nghe khi disconnect
    _socketClient.on('disconnect').listen((_) {
      developer.log('Friend online service disconnected', name: 'FriendOnlineService');
      _isConnected = false;
    });
  }

  /// Yêu cầu số lượng bạn bè online từ server
  void _requestOnlineCount() {
    _socketClient.emit('getOnlineFriendsCount', {});
  }

  /// Cập nhật số lượng bạn bè online
  void _updateOnlineCount(int count) {
    if (_onlineCount != count) {
      _onlineCount = count;
      _onlineCountController.add(_onlineCount);
    }
  }

  /// Yêu cầu refresh số lượng bạn bè online
  void refreshOnlineCount() {
    if (_isConnected && _socketClient.isConnected) {
      _requestOnlineCount();
    }
  }

  /// Ngắt kết nối
  void disconnect() {
    _isConnected = false;
    // Note: Không disconnect socketClient vì có thể đang được dùng bởi service khác
    // Chỉ reset trạng thái của service này
  }

  /// Khởi tạo trạng thái bạn bè từ danh sách bạn bè
  void initializeFriendsStatus(List<String> friendIds) {
    final now = DateTime.now();
    for (final friendId in friendIds) {
      if (!_friendsStatus.containsKey(friendId)) {
        _friendsStatus[friendId] = FriendOnlineStatus(
          isOnline: false,
          lastSeen: null,
        );
      }
    }
    _friendsStatusController.add(Map.unmodifiable(_friendsStatus));
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _onlineCountController.close();
    _friendsStatusController.close();
    _friendsStatus.clear();
  }
}

