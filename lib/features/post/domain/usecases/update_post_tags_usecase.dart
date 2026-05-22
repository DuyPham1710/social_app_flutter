import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class UpdatePostTagsUsecase
    implements UseCase<DataState<void>, UpdatePostTagsParams> {
  final PostRepository _repository;

  UpdatePostTagsUsecase(this._repository);

  @override
  Future<DataState<void>> call({UpdatePostTagsParams? params}) {
    return _repository.updatePostTags(
      postId: params!.postId,
      taggedUserIds: params.taggedUserIds,
    );
  }
}

class UpdatePostTagsParams {
  final String postId;
  final List<String> taggedUserIds;

  const UpdatePostTagsParams({
    required this.postId,
    required this.taggedUserIds,
  });
}
