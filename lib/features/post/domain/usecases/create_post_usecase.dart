import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/entities/create_post_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class CreatePostUsecase
    implements UseCase<DataState<String>, CreatePostEntity> {
  final PostRepository _repository;

  CreatePostUsecase(this._repository);

  @override
  Future<DataState<String>> call({CreatePostEntity? params}) {
    return _repository.createPost(post: params!);
  }
}
