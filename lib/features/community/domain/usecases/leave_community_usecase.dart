import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class LeaveCommunityUseCase extends UseCase<DataState<void>, String> {
  final CommunityRepository _communityRepository;

  LeaveCommunityUseCase(this._communityRepository);

  @override
  Future<DataState<void>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      throw ArgumentError('Community ID cannot be null or empty');
    }
    return await _communityRepository.leaveCommunity(params);
  }
}
