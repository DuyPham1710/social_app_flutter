import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class ReactPostUsecase
    implements UseCase<DataState<ReactPostEntity>, ReactPostParams> {
  final PostRepository _repository;

  ReactPostUsecase(this._repository);

  @override
  Future<DataState<ReactPostEntity>> call({ReactPostParams? params}) {
    final postId = params?.postId;
    final emoji = params?.emoji;

    return _repository.reactPost(postId: postId!, emoji: emoji!);
  }
}

class ReactPostParams {
  final String postId;
  final String emoji;

  const ReactPostParams({required this.postId, required this.emoji});
}
