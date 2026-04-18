import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/data/models/community_request_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class GetMyInvitesUseCase
    extends UseCase<DataState<List<CommunityRequestModel>>, void> {
  final CommunityRepository _communityRepository;

  GetMyInvitesUseCase(this._communityRepository);

  @override
  Future<DataState<List<CommunityRequestModel>>> call({void params}) async {
    return await _communityRepository.getMyInvites();
  }
}
