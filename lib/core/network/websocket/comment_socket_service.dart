import 'dart:async';
import 'dart:developer' as developer;

import 'package:social_app_fe/core/constants/constants.dart';
import 'package:social_app_fe/features/comment/data/models/comment_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CommentSocketService {
  IO.Socket? _socket;
  final _commentAddedController =
      StreamController<CommentUpdateEvent>.broadcast();
  final _commentDeletedController =
      StreamController<CommentDeletedEvent>.broadcast();
  final _commentCountController =
      StreamController<Map<String, int>>.broadcast();
  final _typingController = StreamController<TypingEvent>.broadcast();

  // Map để lưu số comment của mỗi post
  final Map<String, int> _commentCounts = {};

  Stream<CommentUpdateEvent> get commentAddedStream =>
      _commentAddedController.stream;
  Stream<CommentDeletedEvent> get commentDeletedStream =>
      _commentDeletedController.stream;
  Stream<Map<String, int>> get commentCountStream =>
      _commentCountController.stream;
  Stream<TypingEvent> get typingStream => _typingController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect(String userId) {
    if (_socket != null && _socket!.connected) {
      developer.log('Comment socket already connected', name: 'CommentSocket');
      return;
    }

    // Tạo WebSocket URL từ BASE_URL
    final baseUrl = BASE_URL.replaceAll(RegExp(r'/$'), '');
    final socketUrl = baseUrl.replaceAll(RegExp(r'http'), 'ws');

    developer.log(
      'Connecting to comment socket: $socketUrl/comment',
      name: 'CommentSocket',
    );

    _socket = IO.io(
      '$baseUrl/comment',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'userId': userId})
          .build(),
    );

    _socket!.connect();

    // event lắng nghe khi kết nối thành công
    _socket!.onConnect((_) {
      developer.log('Connected to comment socket', name: 'CommentSocket');

      // Gửi event register user với userId
      _socket!.emit('register', {'userId': userId});
    });

    // (on là lắng nghe event) Lắng nghe acknowledgment khi đăng ký user thành công
    _socket!.on('register:ack', (data) {
      developer.log('User registered: $data', name: 'CommentSocket');
    });

    _socket!.on('connected', (data) {
      developer.log('Socket connected: $data', name: 'CommentSocket');
    });

    // Lắng nghe khi có comment mới được thêm
    _socket!.on('commentAdded', (data) {
      developer.log('Comment added: $data', name: 'CommentSocket');
      try {
        final comment = CommentModel.fromJson(data['comment']);
        final postId = data['postId'] as String;

        // Tăng số lượng comment cho post này
        _commentCounts[postId] = (_commentCounts[postId] ?? 0) + 1;

        _commentAddedController.add(
          CommentUpdateEvent(
            comment: comment,
            postId: postId,
            count: _commentCounts[postId]!,
          ),
        );

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
      } catch (e) {
        developer.log('Error parsing commentAdded: $e', name: 'CommentSocket');
      }
    });

    // Lắng nghe acknowledgment khi user tự gửi comment
    _socket!.on('commentAdded:ack', (data) {
      developer.log('Comment added ack: $data', name: 'CommentSocket');
      try {
        final comment = CommentModel.fromJson(data['comment']);
        final postId = data['postId'] as String;

        // Tăng số lượng comment cho post này
        _commentCounts[postId] = (_commentCounts[postId] ?? 0) + 1;

        _commentAddedController.add(
          CommentUpdateEvent(
            comment: comment,
            postId: postId,
            count: _commentCounts[postId]!,
          ),
        );

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
      } catch (e) {
        developer.log(
          'Error parsing commentAdded:ack: $e',
          name: 'CommentSocket',
        );
      }
    });

    // Lắng nghe khi comment bị xóa
    _socket!.on('commentDeleted', (data) {
      developer.log('Comment deleted: $data', name: 'CommentSocket');
      try {
        final commentId = data['id'] as String;
        final postId = data['postId'] as String;

        // Giảm số lượng comment cho post này
        if (_commentCounts.containsKey(postId) && _commentCounts[postId]! > 0) {
          _commentCounts[postId] = _commentCounts[postId]! - 1;
        }

        _commentDeletedController.add(
          CommentDeletedEvent(
            commentId: commentId,
            postId: postId,
            count: _commentCounts[postId] ?? 0,
          ),
        );

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
      } catch (e) {
        developer.log(
          'Error parsing commentDeleted: $e',
          name: 'CommentSocket',
        );
      }
    });

    // Lắng nghe acknowledgment khi user tự xóa comment
    _socket!.on('commentDeleted:ack', (data) {
      developer.log('Comment deleted ack: $data', name: 'CommentSocket');
      try {
        final commentId = data['id'] as String;
        final postId = data['postId'] as String;

        // Giảm số lượng comment cho post này
        if (_commentCounts.containsKey(postId) && _commentCounts[postId]! > 0) {
          _commentCounts[postId] = _commentCounts[postId]! - 1;
        }

        _commentDeletedController.add(
          CommentDeletedEvent(
            commentId: commentId,
            postId: postId,
            count: _commentCounts[postId] ?? 0,
          ),
        );

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
      } catch (e) {
        developer.log(
          'Error parsing commentDeleted:ack: $e',
          name: 'CommentSocket',
        );
      }
    });

    // Lắng nghe khi load comments thành công
    _socket!.on('commentsLoaded', (data) {
      developer.log(
        'Comments loaded: ${data['count']} comments',
        name: 'CommentSocket',
      );
      try {
        final postId = data['postId'] as String;
        final count = data['count'] as int;

        // Cập nhật số lượng comment cho post này
        _commentCounts[postId] = count;

        // Emit stream để UI cập nhật
        _commentCountController.add(Map.from(_commentCounts));
      } catch (e) {
        developer.log(
          'Error parsing commentsLoaded: $e',
          name: 'CommentSocket',
        );
      }
    });

    // Lắng nghe khi có người đang typing
    _socket!.on('userTyping', (data) {
      developer.log('User typing: $data', name: 'CommentSocket');
      try {
        final userId = data['userId'] as String;
        final username = data['username'] as String?;
        final isTyping = data['isTyping'] as bool;
        final postId = data['postId'] as String;

        _typingController.add(
          TypingEvent(
            userId: userId,
            username: username,
            isTyping: isTyping,
            postId: postId,
          ),
        );
      } catch (e) {
        developer.log('Error parsing userTyping: $e', name: 'CommentSocket');
      }
    });

    _socket!.on('error', (data) {
      developer.log('Socket error: $data', name: 'CommentSocket');
    });

    _socket!.onDisconnect((_) {
      developer.log('Disconnected from comment socket', name: 'CommentSocket');
    });

    _socket!.onConnectError((error) {
      developer.log('Connection error: $error', name: 'CommentSocket');
    });
  }

  // Join vào một post để nhận updates
  void joinPost(String postId) {
    if (_socket == null || !_socket!.connected) {
      developer.log(
        'Socket not connected. Cannot join post.',
        name: 'CommentSocket',
      );
      return;
    }

    developer.log('Joining post: $postId', name: 'CommentSocket');
    _socket!.emit('joinPost', {'postId': postId});
  }

  // Leave một post
  void leavePost(String postId) {
    if (_socket == null || !_socket!.connected) {
      return;
    }

    developer.log('Leaving post: $postId', name: 'CommentSocket');
    _socket!.emit('leavePost', {'postId': postId});
  }

  // Load comments của một post để lấy count ban đầu
  void loadComments(String postId) {
    if (_socket == null || !_socket!.connected) {
      developer.log(
        'Socket not connected. Cannot load comments.',
        name: 'CommentSocket',
      );
      return;
    }

    developer.log('Loading comments for post: $postId', name: 'CommentSocket');

    // Gửi event loadComments với postId đến backend
    _socket!.emit('loadComments', {'postId': postId});
  }

  // Gửi comment mới
  void sendComment({
    required String postId,
    required String content,
    String? parentId,
  }) {
    if (_socket == null || !_socket!.connected) {
      developer.log(
        'Socket not connected. Cannot send comment.',
        name: 'CommentSocket',
      );
      return;
    }

    developer.log('Sending comment to post: $postId', name: 'CommentSocket');
    _socket!.emit('newComment', {
      'postId': postId,
      'content': content,
      if (parentId != null) 'parentId': parentId,
    });
  }

  // Xóa comment
  void deleteComment({required String commentId, required String postId}) {
    if (_socket == null || !_socket!.connected) {
      developer.log(
        'Socket not connected. Cannot delete comment.',
        name: 'CommentSocket',
      );
      return;
    }

    developer.log('Deleting comment: $commentId', name: 'CommentSocket');
    _socket!.emit('deleteComment', {'commentId': commentId, 'postId': postId});
  }

  // Emit typing event
  void emitTyping({required String postId, required bool isTyping}) {
    if (_socket == null || !_socket!.connected) {
      developer.log(
        'Socket not connected. Cannot emit typing.',
        name: 'CommentSocket',
      );
      return;
    }

    developer.log(
      'Emitting typing: $isTyping for post: $postId',
      name: 'CommentSocket',
    );
    _socket!.emit('typing', {'postId': postId, 'isTyping': isTyping});
  }

  // Get current comment count for a post
  int getCommentCount(String postId) {
    return _commentCounts[postId] ?? 0;
  }

  void disconnect() {
    developer.log('Disconnecting comment socket', name: 'CommentSocket');
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _commentAddedController.close();
    _commentDeletedController.close();
    _commentCountController.close();
    _typingController.close();
    _commentCounts.clear();
  }
}

// Events
class CommentUpdateEvent {
  final CommentModel comment;
  final String postId;
  final int count;

  CommentUpdateEvent({
    required this.comment,
    required this.postId,
    required this.count,
  });
}

class CommentDeletedEvent {
  final String commentId;
  final String postId;
  final int count;

  CommentDeletedEvent({
    required this.commentId,
    required this.postId,
    required this.count,
  });
}

class TypingEvent {
  final String userId;
  final String? username;
  final bool isTyping;
  final String postId;

  TypingEvent({
    required this.userId,
    required this.username,
    required this.isTyping,
    required this.postId,
  });
}
