import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/params/update_comment_params.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class UpdateCommentUsecase implements SyncUseCase<void, UpdateCommentParams> {
  final CommentRepository _commentRepository;

  UpdateCommentUsecase(this._commentRepository);

  @override
  void call({UpdateCommentParams? params}) {
    assert(params != null);
    return _commentRepository.updateComment(params!);
  }
}
