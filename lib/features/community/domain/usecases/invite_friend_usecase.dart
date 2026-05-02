import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class InviteFriendUseCase
    implements UseCase<DataState<void>, InviteFriendParams> {
  final CommunityRepository _communityRepository;

  InviteFriendUseCase(this._communityRepository);

  @override
  Future<DataState<void>> call({InviteFriendParams? params}) {
    return _communityRepository.inviteFriend(
      communityId: params!.communityId,
      userId: params.userId,
    );
  }
}

class InviteFriendParams {
  final String communityId;
  final String userId;

  InviteFriendParams({required this.communityId, required this.userId});
}
