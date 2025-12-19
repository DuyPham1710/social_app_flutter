import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/entities/react_comment_entity.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class ReactCommentUsecase
    implements UseCase<DataState<ReactCommentEntity>, ReactCommentParams> {
  final CommentRepository _repository;

  ReactCommentUsecase(this._repository);

  @override
  Future<DataState<ReactCommentEntity>> call({ReactCommentParams? params}) {
    final commentId = params?.commentId;
    final emoji = params?.emoji;

    return _repository.reactComment(commentId: commentId!, emoji: emoji!);
  }
}

class ReactCommentParams {
  final String commentId;
  final String emoji;

  const ReactCommentParams({required this.commentId, required this.emoji});
}


