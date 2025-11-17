import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class LoadCommentHistoryUseCase implements UseCase<void, LoadCommentHistoryParams> {
  final CommentRepository _repository;

  LoadCommentHistoryUseCase(this._repository);

  @override
  Future<void> call({LoadCommentHistoryParams? params}) async {
    _repository.loadCommentHistory(params!.commentId);
  }
}

class LoadCommentHistoryParams {
  final String commentId;

  LoadCommentHistoryParams(this.commentId);
}
