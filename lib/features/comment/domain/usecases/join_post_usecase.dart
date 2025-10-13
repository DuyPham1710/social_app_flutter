import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

/// UseCase để join vào post room
class JoinPostUseCase implements SyncUseCase<void, JoinPostParams> {
  final CommentRepository _repository;

  JoinPostUseCase(this._repository);

  @override
  void call({required JoinPostParams params}) {
    _repository.joinPost(params.postId);
  }
}

class JoinPostParams {
  final String postId;

  JoinPostParams(this.postId);
}
