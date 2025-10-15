import 'package:social_app_fe/features/comment/data/data_sources/remote/comment_remote_data_source.dart';
import 'package:social_app_fe/features/comment/domain/entities/typing_entity.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource _remoteDataSource;

  CommentRepositoryImpl(this._remoteDataSource);

  @override
  void connect(String userId, String username) {
    _remoteDataSource.connect(userId, username);
  }

  @override
  void joinPost(String postId) {
    _remoteDataSource.joinPost(postId);
  }

  @override
  void leavePost(String postId) {
    _remoteDataSource.leavePost(postId);
  }

  @override
  void emitTyping({required String postId, required bool isTyping}) {
    _remoteDataSource.emitTyping(postId: postId, isTyping: isTyping);
  }

  @override
  void loadComments(String postId) {
    _remoteDataSource.loadComments(postId);
  }

  @override
  int getCommentCount(String postId) {
    return _remoteDataSource.getCommentCount(postId);
  }

  @override
  Stream<TypingEntity> get typingStream => _remoteDataSource.typingStream;

  @override
  Stream<Map<String, int>> get commentCountStream =>
      _remoteDataSource.commentCountStream;

  @override
  void disconnect() {
    _remoteDataSource.disconnect();
  }
}
