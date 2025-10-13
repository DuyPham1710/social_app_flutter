import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

/// UseCase để lắng nghe real-time comment count updates
class ListenCommentCountUseCase
    implements StreamUseCase<Map<String, int>, NoParams> {
  final CommentRepository _repository;

  ListenCommentCountUseCase(this._repository);

  @override
  Stream<Map<String, int>> call({required NoParams params}) {
    return _repository.commentCountStream;
  }
}

