import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/entities/post_list_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class GetUserCommunityPostsUseCase
    implements UseCase<DataState<PostListEntity>, GetUserCommunityPostsParams> {
  final PostRepository _repository;

  GetUserCommunityPostsUseCase(this._repository);

  @override
  Future<DataState<PostListEntity>> call({
    GetUserCommunityPostsParams? params,
  }) {
    return _repository.getUserCommunityPosts(
      page: params?.page ?? 1,
      limit: params?.limit ?? 10,
      status: params?.status ?? 'all',
    );
  }
}

class GetUserCommunityPostsParams {
  final int page;
  final int limit;
  final String status; // 'all', 'pending', 'approved'

  const GetUserCommunityPostsParams({
    this.page = 1,
    this.limit = 10,
    this.status = 'all',
  });
}
