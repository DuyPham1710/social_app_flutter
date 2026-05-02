import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class GetAvailableFriendsUseCase
    implements UseCase<DataState<List<dynamic>>, GetAvailableFriendsParams> {
  final CommunityRepository _communityRepository;

  GetAvailableFriendsUseCase(this._communityRepository);

  @override
  Future<DataState<List<dynamic>>> call({GetAvailableFriendsParams? params}) {
    return _communityRepository.getAvailableFriends(
      communityId: params!.communityId,
    );
  }
}

class GetAvailableFriendsParams {
  final String communityId;

  GetAvailableFriendsParams({required this.communityId});
}
