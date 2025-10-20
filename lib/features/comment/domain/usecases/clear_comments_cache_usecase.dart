import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class ClearCommentsCacheUseCase
    implements UseCase<void, ClearCommentsCacheParams> {
  final CommentRepository _repository;

  ClearCommentsCacheUseCase(this._repository);

  @override
  Future<void> call({ClearCommentsCacheParams? params}) async {
    return _repository.clearCommentsCache(params!.postId);
  }
}

class ClearCommentsCacheParams {
  final String postId;

  ClearCommentsCacheParams(this.postId);
}
