import 'dart:async';
import 'dart:developer' as developer;

import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/comment/data/models/comments_loaded_model.dart';
import 'package:social_app_fe/features/comment/data/models/comment-log_loaded_model.dart';
import 'package:social_app_fe/features/comment/data/models/typing_event_model.dart';
import 'package:social_app_fe/features/comment/domain/params/add_comment_params.dart';
import 'package:social_app_fe/features/comment/domain/params/delete_comment_params.dart';
import 'package:social_app_fe/features/comment/domain/params/update_comment_params.dart';

class CommentRemoteDataSource {
  final SocketClient _socketClient;

  // StreamControllers cho các events
  final _commentCountController =
      StreamController<Map<String, int>>.broadcast();
  final _commentsLoadedController =
      StreamController<CommentsLoadedModel>.broadcast();
  final _commentHistoryLoadedController =
      StreamController<CommentLogsLoadedModel>.broadcast();
  final _typingController = StreamController<TypingEventModel>.broadcast();

  // Map để lưu số comment của mỗi post
  final Map<String, int> _commentCounts = {};

  // Map để lưu comments loaded data của mỗi post
  final Map<String, CommentsLoadedModel> _commentsLoadedData = {};

  CommentRemoteDataSource(this._socketClient);

  // Getters
  Stream<Map<String, int>> get commentCountStream =>
      _commentCountController.stream;
  Stream<CommentsLoadedModel> get commentsLoadedStream =>
      _commentsLoadedController.stream;
  Stream<CommentLogsLoadedModel> get commentHistoryLoadedStream =>
      _commentHistoryLoadedController.stream;
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
    _setupCommentHistoryListeners();
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
        // Parse toàn bộ dữ liệu comments loaded
        final commentsLoadedModel = CommentsLoadedModel.fromJson(data);
        final postId = commentsLoadedModel.postId;
        final count = commentsLoadedModel.count;

        // Cập nhật số lượng comment cho post này
        _commentCounts[postId] = count;

        // Lưu trữ dữ liệu comments loaded đầy đủ
        _commentsLoadedData[postId] = commentsLoadedModel;

        // Emit cả hai streams
        _commentCountController.add(Map.from(_commentCounts));
        _commentsLoadedController.add(commentsLoadedModel);

        developer.log(
          'Stored comments loaded data for post $postId: ${commentsLoadedModel.comments.length} comments at ${commentsLoadedModel.timestamp}',
          name: 'CommentDataSource',
        );
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
        //   final postId = data['postId'] as String;
        final commentsLoadedModel = CommentsLoadedModel.fromJson(data);
        final postId = commentsLoadedModel.postId;

        // Tăng số lượng comment cho post này
        _commentCounts[postId] = (_commentCounts[postId] ?? 0) + 1;

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
        _commentsLoadedController.add(commentsLoadedModel);
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
        //final postId = data['postId'] as String;
        final commentsLoadedModel = CommentsLoadedModel.fromJson(data);
        final postId = commentsLoadedModel.postId;

        // Tăng số lượng comment cho post này
        _commentCounts[postId] = (_commentCounts[postId] ?? 0) + 1;

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
        _commentsLoadedController.add(commentsLoadedModel);
      } catch (e) {
        developer.log(
          'Error parsing commentAdded:ack: $e',
          name: 'CommentDataSource',
        );
      }
    });

    // Lắng nghe khi comment bị cập nhật
    _socketClient.on('commentUpdated').listen((data) {
      developer.log('Comment updated event', name: 'CommentDataSource');
      try {
        final commentsLoadedModel = CommentsLoadedModel.fromJson(data);

        // Chỉ emit commentsLoadedModel mới
        _commentsLoadedController.add(commentsLoadedModel);
      } catch (e) {
        developer.log(
          'Error parsing commentUpdated: $e',
          name: 'CommentDataSource',
        );
      }
    });

    _socketClient.on('commentUpdated:ack').listen((data) {
      developer.log('Comment updated ack event', name: 'CommentDataSource');
      try {
        final commentsLoadedModel = CommentsLoadedModel.fromJson(data);

        // Chỉ emit commentsLoadedModel mới
        _commentsLoadedController.add(commentsLoadedModel);
      } catch (e) {
        developer.log(
          'Error parsing commentUpdated:ack: $e',
          name: 'CommentDataSource',
        );
      }
    });

    // Lắng nghe khi comment bị xóa
    _socketClient.on('commentDeleted').listen((data) {
      developer.log('Comment deleted event', name: 'CommentDataSource');
      try {
        final commentsLoadedModel = CommentsLoadedModel.fromJson(data);
        final postId = commentsLoadedModel.postId;

        // Giảm số lượng comment cho post này
        if (_commentCounts.containsKey(postId) && _commentCounts[postId]! > 0) {
          _commentCounts[postId] = _commentCounts[postId]! - 1;
        }

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
        _commentsLoadedController.add(commentsLoadedModel);
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
        final commentsLoadedModel = CommentsLoadedModel.fromJson(data);
        final postId = commentsLoadedModel.postId;

        // Giảm số lượng comment cho post này
        if (_commentCounts.containsKey(postId) && _commentCounts[postId]! > 0) {
          _commentCounts[postId] = _commentCounts[postId]! - 1;
        }

        // Emit updated counts
        _commentCountController.add(Map.from(_commentCounts));
        _commentsLoadedController.add(commentsLoadedModel);
      } catch (e) {
        developer.log(
          'Error parsing commentDeleted:ack: $e',
          name: 'CommentDataSource',
        );
      }
    });
  }

  /// Setup listeners cho comment history events
  void _setupCommentHistoryListeners() {
    _socketClient.on('commentHistoryLoaded').listen((data) {
      developer.log(
        'Comment history loaded event',
        name: 'CommentDataSource',
      );
      try {
        final commentHistoryLoadedModel = CommentLogsLoadedModel.fromJson(data);
        _commentHistoryLoadedController.add(commentHistoryLoadedModel);
        
        developer.log(
          'Loaded ${commentHistoryLoadedModel.count} history entries for comment ${commentHistoryLoadedModel.commentId}',
          name: 'CommentDataSource',
        );
      } catch (e) {
        developer.log(
          'Error parsing commentHistoryLoaded: $e',
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

  /// Load comment history của một comment
  void loadCommentHistory(String commentId) {
    developer.log(
      'Loading comment history for comment: $commentId',
      name: 'CommentDataSource',
    );
    _socketClient.emit('loadCommentHistory', {'commentId': commentId});
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

  /// Get comments loaded data for a post
  CommentsLoadedModel? getCommentsLoadedData(String postId) {
    final data = _commentsLoadedData[postId];
    developer.log(
      'Getting cached data for post $postId: ${data?.count ?? 0} comments, cache size: ${_commentsLoadedData.length}',
      name: 'CommentDataSource',
    );
    return data;
  }

  /// Clear cached comments data for a post and force reload
  void clearCommentsCache(String postId) {
    developer.log(
      'Clearing comments cache for post: $postId (had ${_commentsLoadedData[postId]?.count ?? 0} comments)',
      name: 'CommentDataSource',
    );
    _commentsLoadedData.remove(postId);
    // Force reload comments from server
    loadComments(postId);
    developer.log(
      'Cache cleared and reload requested for post: $postId',
      name: 'CommentDataSource',
    );
  }

  void addComment(AddCommentParams params) async {
    developer.log(
      'Sending new comment for post: ${params.postId}',
      name: 'CommentRemoteDataSource',
    );
    _socketClient.emit('newComment', params.toJson());
  }

  void updateComment(UpdateCommentParams params) async {
    developer.log(
      'Sending update comment for post: ${params.postId}, comment: ${params.commentId}',
      name: 'CommentRemoteDataSource',
    );
    _socketClient.emit('updateComment', params.toJson());
  }

  void deleteComment(DeleteCommentParams params) async {
    developer.log(
      'Sending delete comment for post: ${params.postId}, comment: ${params.commentId}',
      name: 'CommentRemoteDataSource',
    );
    _socketClient.emit('deleteComment', params.toJson());
  }

  /// Disconnect
  void disconnect() {
    _socketClient.disconnect();
  }

  /// Dispose tất cả resources
  void dispose() {
    disconnect();
    _commentCountController.close();
    _commentsLoadedController.close();
    _commentHistoryLoadedController.close();
    _typingController.close();
    _commentCounts.clear();
    _commentsLoadedData.clear();
  }
}
