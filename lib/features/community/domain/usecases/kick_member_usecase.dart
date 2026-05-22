import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class KickMemberParams {
  final String communityId;
  final String memberId;

  KickMemberParams({required this.communityId, required this.memberId});
}

class KickMemberUseCase implements UseCase<DataState<void>, KickMemberParams> {
  final CommunityRepository _communityRepository;

  KickMemberUseCase(this._communityRepository);

  @override
  Future<DataState<void>> call({KickMemberParams? params}) async {
    return await _communityRepository.kickMember(
      communityId: params!.communityId,
      memberId: params.memberId,
    );
  }
}
