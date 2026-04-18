import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class RespondToInviteUseCase
    extends UseCase<DataState<void>, RespondToInviteParams> {
  final CommunityRepository _communityRepository;

  RespondToInviteUseCase(this._communityRepository);

  @override
  Future<DataState<void>> call({RespondToInviteParams? params}) async {
    if (params == null) {
      throw ArgumentError('RespondToInviteParams cannot be null');
    }
    return await _communityRepository.respondToInvite(
      communityId: params.communityId,
      requestId: params.requestId,
      action: params.action,
    );
  }
}

class RespondToInviteParams {
  final String communityId;
  final String requestId;
  final String action;

  RespondToInviteParams({
    required this.communityId,
    required this.requestId,
    required this.action,
  });
}
