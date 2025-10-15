import 'dart:async';
import 'dart:developer' as developer;

import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/comment/data/models/typing_event_model.dart';

class CommentRemoteDataSource {
  final SocketClient _socketClient;

  // StreamControllers cho các events
  final _commentCountController =
      StreamController<Map<String, int>>.broadcast();
  final _typingController = StreamController<TypingEventModel>.broadcast();

  // Map để lưu số comment của mỗi post
  final Map<String, int> _commentCounts = {};

  CommentRemoteDataSource(this._socketClient);

  // Getters
  Stream<Map<String, int>> get commentCountStream =>
      _commentCountController.stream;
  Stream<TypingEventModel> get typingStream => _typingController.stream;

  /// Connect đến comment namespace
  void connect(String userId, String username) {
    _socketClient.connect(
      namespace: 'comment',
      userId: userId,
      username: username,
    );

    // Setup listeners
    _setupCommentCountListeners();
    _setupTypingListeners();
  }

  /// Setup listeners cho comment count events
  void _setupCommentCountListeners() {
    // Lắng nghe khi load comments thành công
    _socketClient.on('commentsLoaded').listen((data) {
      developer.log(
        'Comments loaded: ${data['count']} comments',
        name: 'CommentDataSource',
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
          name: 'CommentDataSource',
        );
      }
    });

    // Lắng nghe khi có comment mới
    _socketClient.on('commentAdded').listen((data) {
      developer.log('Comment added event', name: 'CommentDataSource');
      try {
        final postId = data['postId'] as String;

        // Tăng số lượng comment cho post này
        _commentCounts[postId] = (_commentCounts[postId] ?? 0) + 1;

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
      } catch (e) {
        developer.log(
          'Error parsing commentAdded: $e',
          name: 'CommentDataSource',
        );
      }
    });

    // Lắng nghe acknowledgment khi user tự gửi comment
    _socketClient.on('commentAdded:ack').listen((data) {
      developer.log('Comment added ack event', name: 'CommentDataSource');
      try {
        final postId = data['postId'] as String;

        // Tăng số lượng comment cho post này
        _commentCounts[postId] = (_commentCounts[postId] ?? 0) + 1;

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
      } catch (e) {
        developer.log(
          'Error parsing commentAdded:ack: $e',
          name: 'CommentDataSource',
        );
      }
    });

    // Lắng nghe khi comment bị xóa
    _socketClient.on('commentDeleted').listen((data) {
      developer.log('Comment deleted event', name: 'CommentDataSource');
      try {
        final postId = data['postId'] as String;

        // Giảm số lượng comment cho post này
        if (_commentCounts.containsKey(postId) && _commentCounts[postId]! > 0) {
          _commentCounts[postId] = _commentCounts[postId]! - 1;
        }

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
      } catch (e) {
        developer.log(
          'Error parsing commentDeleted: $e',
          name: 'CommentDataSource',
        );
      }
    });

    // Lắng nghe acknowledgment khi user tự xóa comment
    _socketClient.on('commentDeleted:ack').listen((data) {
      developer.log('Comment deleted ack event', name: 'CommentDataSource');
      try {
        final postId = data['postId'] as String;

        // Giảm số lượng comment cho post này
        if (_commentCounts.containsKey(postId) && _commentCounts[postId]! > 0) {
          _commentCounts[postId] = _commentCounts[postId]! - 1;
        }

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
      } catch (e) {
        developer.log(
          'Error parsing commentDeleted:ack: $e',
          name: 'CommentDataSource',
        );
      }
    });
  }

  /// Setup listeners cho typing events
  void _setupTypingListeners() {
    _socketClient.on('userTyping').listen((data) {
      developer.log('User typing event', name: 'CommentDataSource');
      try {
        final typingEvent = TypingEventModel.fromJson(data);
        _typingController.add(typingEvent);
      } catch (e) {
        developer.log(
          'Error parsing userTyping: $e',
          name: 'CommentDataSource',
        );
      }
    });
  }

  /// Join vào một post để nhận updates về count
  void joinPost(String postId) {
    developer.log('Joining post: $postId', name: 'CommentDataSource');
    _socketClient.emit('joinPost', {'postId': postId});

    // Load comments để lấy count ban đầu
    // loadComments(postId);
  }

  /// Leave một post
  void leavePost(String postId) {
    _socketClient.emit('leavePost', {'postId': postId});
  }

  /// Load comments của một post để lấy count ban đầu
  void loadComments(String postId) {
    developer.log(
      'Loading comments for post: $postId',
      name: 'CommentDataSource',
    );
    _socketClient.emit('loadComments', {'postId': postId});
  }

  /// Emit typing event
  void emitTyping({required String postId, required bool isTyping}) {
    developer.log(
      'Emitting typing: $isTyping for post: $postId',
      name: 'CommentDataSource',
    );
    _socketClient.emit('typing', {'postId': postId, 'isTyping': isTyping});
  }

  /// Get current comment count for a post
  int getCommentCount(String postId) {
    return _commentCounts[postId] ?? 0;
  }

  /// Disconnect
  void disconnect() {
    _socketClient.disconnect();
  }

  /// Dispose tất cả resources
  void dispose() {
    disconnect();
    _commentCountController.close();
    _typingController.close();
    _commentCounts.clear();
  }
}
