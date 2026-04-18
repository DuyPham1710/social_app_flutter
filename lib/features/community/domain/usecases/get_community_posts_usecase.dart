import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/data/models/community_post_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class GetCommunityPostsUseCase
    extends
        UseCase<DataState<List<CommunityPostModel>>, GetCommunityPostsParams> {
  final CommunityRepository _communityRepository;

  GetCommunityPostsUseCase(this._communityRepository);

  @override
  Future<DataState<List<CommunityPostModel>>> call({
    GetCommunityPostsParams? params,
  }) async {
    if (params == null) {
      throw ArgumentError('GetCommunityPostsParams cannot be null');
    }
    return await _communityRepository.getCommunityPosts(
      communityId: params.communityId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCommunityPostsParams {
  final String communityId;
  final int page;
  final int limit;

  GetCommunityPostsParams({
    required this.communityId,
    required this.page,
    required this.limit,
  });
}
