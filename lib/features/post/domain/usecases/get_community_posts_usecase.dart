import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/entities/post_list_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class GetCommunityPostsUseCase
    implements UseCase<DataState<PostListEntity>, GetCommunityPostsParams> {
  final PostRepository _repository;

  GetCommunityPostsUseCase(this._repository);

  @override
  Future<DataState<PostListEntity>> call({GetCommunityPostsParams? params}) {
    return _repository.getCommunityPosts(
      communityId: params?.communityId ?? '',
      page: params?.page ?? 1,
      limit: params?.limit ?? 10,
    );
  }
}

class GetCommunityPostsParams {
  final String communityId;
  final int page;
  final int limit;

  const GetCommunityPostsParams({
    required this.communityId,
    this.page = 1,
    this.limit = 10,
  });
}
