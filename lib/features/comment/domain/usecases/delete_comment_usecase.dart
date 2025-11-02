import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/params/delete_comment_params.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class DeleteCommentUsecase implements SyncUseCase<void, DeleteCommentParams> {
  final CommentRepository _commentRepository;

  DeleteCommentUsecase(this._commentRepository);

  @override
  void call({DeleteCommentParams? params}) {
    assert(params != null);
    return _commentRepository.deleteComment(params!);
  }
}
