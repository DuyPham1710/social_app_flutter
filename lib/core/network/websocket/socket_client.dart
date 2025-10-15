import 'dart:async';
import 'dart:developer' as developer;

import 'package:social_app_fe/core/constants/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Generic WebSocket client - có thể dùng cho mọi features (comments, chat, notifications)
class SocketClient {
  IO.Socket? _socket;
  String? _currentNamespace;
  final Map<String, StreamController<dynamic>> _eventControllers = {};

  bool get isConnected => _socket?.connected ?? false;

  /// Connect đến một namespace cụ thể
  void connect({
    required String namespace,
    required String userId,
    required String username,
  }) {
    if (_socket != null &&
        _socket!.connected &&
        _currentNamespace == namespace) {
      developer.log(
        'Already connected to namespace: $namespace',
        name: 'SocketClient',
      );
      return;
    }

    // Disconnect nếu đang connect đến namespace khác
    if (_socket != null && _currentNamespace != namespace) {
      disconnect();
    }

    final baseUrl = BASE_URL.replaceAll(RegExp(r'/$'), '');
    final socketUrl = baseUrl.replaceAll(RegExp(r'http'), 'ws');
    _currentNamespace = namespace;

    developer.log(
      'Connecting to namespace: $socketUrl/$namespace',
      name: 'SocketClient',
    );

    _socket = IO.io(
      '$baseUrl/$namespace',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'userId': userId})
          .build(),
    );

    _socket!.connect();

    // event lắng nghe khi kết nối thành công
    _socket!.on('connected', (data) {
      developer.log('Connected to $namespace', name: 'SocketClient');

      // Emit register event sau khi connect
      _socket!.emit('register', {'userId': userId, 'username': username});
    });

    _socket!.onDisconnect((_) {
      developer.log('Disconnected from $namespace', name: 'SocketClient');
    });

    _socket!.onConnectError((error) {
      developer.log('Connection error: $error', name: 'SocketClient');
    });
  }

  /// Emit event đến server
  void emit(String event, dynamic data) {
    if (_socket == null || !_socket!.connected) {
      developer.log(
        'Cannot emit $event - socket not connected',
        name: 'SocketClient',
      );
      return;
    }

    developer.log('Emitting event: $event', name: 'SocketClient');
    _socket!.emit(event, data);
  }

  /// Lắng nghe event từ server - trả về Stream
  Stream<dynamic> on(String event) {
    if (!_eventControllers.containsKey(event)) {
      _eventControllers[event] = StreamController<dynamic>.broadcast();

      _socket?.on(event, (data) {
        developer.log('Received event: $event', name: 'SocketClient');
        _eventControllers[event]?.add(data);
      });
    }

    return _eventControllers[event]!.stream;
  }

  /// Disconnect khỏi socket
  void disconnect() {
    if (_socket != null) {
      developer.log(
        'Disconnecting from $_currentNamespace',
        name: 'SocketClient',
      );
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _currentNamespace = null;
    }
  }

  /// Dispose tất cả resources
  void dispose() {
    disconnect();
    for (var controller in _eventControllers.values) {
      controller.close();
    }
    _eventControllers.clear();
  }
}
