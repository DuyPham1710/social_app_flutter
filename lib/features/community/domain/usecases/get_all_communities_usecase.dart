import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/data/models/community_list_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class GetAllCommunitiesUseCase
    extends UseCase<DataState<CommunityListModel>, GetAllCommunitiesParams> {
  final CommunityRepository _communityRepository;

  GetAllCommunitiesUseCase(this._communityRepository);

  @override
  Future<DataState<CommunityListModel>> call({
    GetAllCommunitiesParams? params,
  }) async {
    // Handle null case - use default values
    final finalParams = params ?? GetAllCommunitiesParams(page: 1, limit: 10);

    return await _communityRepository.getAllCommunities(
      page: finalParams.page,
      limit: finalParams.limit,
      search: finalParams.search,
    );
  }
}

class GetAllCommunitiesParams {
  final int page;
  final int limit;
  final String? search;

  GetAllCommunitiesParams({
    required this.page,
    required this.limit,
    this.search,
  });
}
