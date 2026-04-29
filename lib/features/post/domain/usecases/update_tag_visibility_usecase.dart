import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class UpdateTagVisibilityUsecase implements UseCase<DataState<void>, UpdateTagVisibilityParams> {
  final PostRepository _repository;

  UpdateTagVisibilityUsecase(this._repository);

  @override
  Future<DataState<void>> call({UpdateTagVisibilityParams? params}) {
    return _repository.updateTagVisibility(
      postId: params!.postId,
      isVisible: params.isVisible,
    );
  }
}

class UpdateTagVisibilityParams {
  final String postId;
  final bool isVisible;

  const UpdateTagVisibilityParams({required this.postId, required this.isVisible});
}
