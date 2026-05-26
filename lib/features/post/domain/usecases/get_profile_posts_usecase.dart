import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/entities/post_list_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class GetProfilePostsUseCase
    implements UseCase<DataState<PostListEntity>, GetProfilePostsParams> {
  final PostRepository _repository;

  GetProfilePostsUseCase(this._repository);

  @override
  Future<DataState<PostListEntity>> call({GetProfilePostsParams? params}) {
    return _repository.getProfilePosts(
      page: params?.page ?? 1,
      limit: params?.limit ?? 10,
    );
  }
}

class GetProfilePostsParams {
  final int page;
  final int limit;

  const GetProfilePostsParams({this.page = 1, this.limit = 2});
}
