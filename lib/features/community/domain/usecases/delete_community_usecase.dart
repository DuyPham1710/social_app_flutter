import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class DeleteCommunityUseCase implements UseCase<DataState<void>, String> {
  final CommunityRepository _communityRepository;

  DeleteCommunityUseCase(this._communityRepository);

  @override
  Future<DataState<void>> call({String? params}) async {
    return await _communityRepository.deleteCommunity(params!);
  }
}
