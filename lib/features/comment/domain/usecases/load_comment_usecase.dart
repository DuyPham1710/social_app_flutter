import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class LoadCommentsUseCase implements SyncUseCase<void, LoadCommentsParams> {
  final CommentRepository _repository;

  LoadCommentsUseCase(this._repository);

  @override
  void call({required LoadCommentsParams params}) {
    _repository.loadComments(params.postId); // Join sẽ tự động load comments
  }
}

class LoadCommentsParams {
  final String postId;

  LoadCommentsParams(this.postId);
}
