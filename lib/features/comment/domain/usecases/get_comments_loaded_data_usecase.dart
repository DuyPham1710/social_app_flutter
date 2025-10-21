import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/entities/comments_loaded_entity.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class GetCommentsLoadedDataUseCase
    implements
        UseCase<DataState<CommentsLoadedEntity?>, GetCommentsLoadedDataParams> {
  final CommentRepository _repository;

  GetCommentsLoadedDataUseCase(this._repository);

  @override
  Future<DataState<CommentsLoadedEntity?>> call({
    GetCommentsLoadedDataParams? params,
  }) async {
    return await _repository.getCommentsLoadedData(params!.postId);
  }
}

class GetCommentsLoadedDataParams {
  final String postId;

  GetCommentsLoadedDataParams(this.postId);
}
