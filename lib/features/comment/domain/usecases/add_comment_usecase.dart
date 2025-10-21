import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/params/add_comment_params.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class AddCommentUseCase implements SyncUseCase<void, AddCommentParams> {
  final CommentRepository _commentRepository;

  AddCommentUseCase(this._commentRepository);

  @override
  void call({AddCommentParams? params}) {
    assert(params != null);
    return _commentRepository.addComment(params!);
  }
}
