import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class ViewPostUsecase implements UseCase<DataState<void>, ViewPostParams> {
  final PostRepository _repository;

  ViewPostUsecase(this._repository);

  @override
  Future<DataState<void>> call({ViewPostParams? params}) {
    final postId = params?.postId;
    return _repository.viewPost(postId: postId!);
  }
}

class ViewPostParams {
  final String postId;

  const ViewPostParams({required this.postId});
}
