import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment-log_loaded_entity.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class ListenCommentHistoryUseCase implements UseCase<Stream<CommentLogsLoadedEntity>, NoParams> {
  final CommentRepository _repository;

  ListenCommentHistoryUseCase(this._repository);

  @override
  Future<Stream<CommentLogsLoadedEntity>> call({NoParams? params}) async {
    return _repository.commentHistoryLoadedStream;
  }
}
