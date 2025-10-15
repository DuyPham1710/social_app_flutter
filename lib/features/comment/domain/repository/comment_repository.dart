import 'package:social_app_fe/features/comment/domain/entities/typing_entity.dart';

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

  /// Disconnect
  void disconnect();
}
