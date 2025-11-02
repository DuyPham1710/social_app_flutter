import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/comment/domain/entities/comments_loaded_entity.dart';
import 'package:social_app_fe/features/comment/domain/entities/typing_entity.dart';
import 'package:social_app_fe/features/comment/domain/params/add_comment_params.dart';
import 'package:social_app_fe/features/comment/domain/params/delete_comment_params.dart';

abstract class CommentRepository {
  /// Connect to comment socket
  void connect(String userId, String username);

  /// Join vào một post
  void joinPost(String postId);

  /// Leave một post
  void leavePost(String postId);

  /// Emit typing status
  void emitTyping({required String postId, required bool isTyping});

  void loadComments(String postId);

  /// Get comment count cho một post
  int getCommentCount(String postId);

  /// Stream để lắng nghe typing events
  Stream<TypingEntity> get typingStream;

  /// Stream để lắng nghe comment count updates
  Stream<Map<String, int>> get commentCountStream;

  /// Stream để lắng nghe comments loaded events
  Stream<CommentsLoadedEntity> get commentsLoadedStream;

  /// Get comments loaded data cho một post
  Future<DataState<CommentsLoadedEntity?>> getCommentsLoadedData(String postId);

  Future<void> clearCommentsCache(String postId);

  void addComment(AddCommentParams params);

  void deleteComment(DeleteCommentParams params);

  /// Disconnect
  void disconnect();
}
