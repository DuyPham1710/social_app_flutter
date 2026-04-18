import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class GetCommunityDetailUseCase
    extends UseCase<DataState<CommunityModel>, String> {
  final CommunityRepository _communityRepository;

  GetCommunityDetailUseCase(this._communityRepository);

  @override
  Future<DataState<CommunityModel>> call({String? params}) async {
    // Handle null case - throw error or return default
    if (params == null || params.isEmpty) {
      throw ArgumentError('Community ID cannot be null or empty');
    }
    return await _communityRepository.getCommunityDetail(params);
  }
}
