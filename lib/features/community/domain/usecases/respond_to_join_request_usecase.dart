import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class RespondToJoinRequestUseCase
    extends UseCase<DataState<void>, RespondToJoinRequestParams> {
  final CommunityRepository _communityRepository;

  RespondToJoinRequestUseCase(this._communityRepository);

  @override
  Future<DataState<void>> call({RespondToJoinRequestParams? params}) async {
    if (params == null) {
      throw ArgumentError('RespondToJoinRequestParams cannot be null');
    }
    return await _communityRepository.respondToJoinRequest(
      communityId: params.communityId,
      requestId: params.requestId,
      action: params.action,
    );
  }
}

class RespondToJoinRequestParams {
  final String communityId;
  final String requestId;
  final String action;

  RespondToJoinRequestParams({
    required this.communityId,
    required this.requestId,
    required this.action,
  });
}
