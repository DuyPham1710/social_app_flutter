import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

/// UseCase để connect comment socket
class ConnectCommentSocketUseCase
    implements SyncUseCase<void, ConnectCommentSocketParams> {
  final CommentRepository _repository;

  ConnectCommentSocketUseCase(this._repository);

  @override
  void call({required ConnectCommentSocketParams params}) {
    _repository.connect(params.userId, params.username);
  }
}

class ConnectCommentSocketParams {
  final String userId;
  final String username;

  ConnectCommentSocketParams(this.userId, this.username);
}
