import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

/// UseCase để lấy số lượng comment của một post
class GetCommentCountUseCase {
  final CommentRepository _repository;

  GetCommentCountUseCase(this._repository);

  /// Get comment count for a specific post
  int call(String postId) {
    return _repository.getCommentCount(postId);
  }
}

