import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

/// UseCase để leave post room
class LeavePostUseCase implements SyncUseCase<void, LeavePostParams> {
  final CommentRepository _repository;

  LeavePostUseCase(this._repository);

  @override
  void call({required LeavePostParams params}) {
    _repository.leavePost(params.postId);
  }
}

class LeavePostParams {
  final String postId;

  LeavePostParams(this.postId);
}
