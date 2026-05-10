import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class DeletePostUsecase implements UseCase<DataState<void>, DeletePostParams> {
  final PostRepository _repository;

  DeletePostUsecase(this._repository);

  @override
  Future<DataState<void>> call({DeletePostParams? params}) {
    return _repository.deletePost(postId: params!.postId);
  }
}

class DeletePostParams {
  final String postId;

  const DeletePostParams({required this.postId});
}
