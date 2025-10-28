import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/entities/comments_loaded_entity.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

/// UseCase để lắng nghe comments loaded event
class ListenCommentsLoadedUseCase
    implements StreamUseCase<CommentsLoadedEntity, NoParams> {
  final CommentRepository _repository;

  ListenCommentsLoadedUseCase(this._repository);

  @override
  Stream<CommentsLoadedEntity> call({required NoParams params}) {
    return _repository.commentsLoadedStream;
  }
}
