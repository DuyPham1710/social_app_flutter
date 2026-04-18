import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/data/models/community_request_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class GetPendingRequestsUseCase
    extends UseCase<DataState<List<CommunityRequestModel>>, String> {
  final CommunityRepository _communityRepository;

  GetPendingRequestsUseCase(this._communityRepository);

  @override
  Future<DataState<List<CommunityRequestModel>>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      throw ArgumentError('Community ID cannot be null or empty');
    }
    return await _communityRepository.getPendingRequests(params);
  }
}
