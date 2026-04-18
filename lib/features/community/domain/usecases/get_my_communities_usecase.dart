import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class GetMyCommunitiesUseCase
    extends UseCase<DataState<List<CommunityModel>>, void> {
  final CommunityRepository _communityRepository;

  GetMyCommunitiesUseCase(this._communityRepository);

  @override
  Future<DataState<List<CommunityModel>>> call({void params}) async {
    return await _communityRepository.getMyCommunities();
  }
}
