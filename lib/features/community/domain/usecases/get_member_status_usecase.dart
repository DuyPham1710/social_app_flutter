import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/data/models/member_status_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class GetMemberStatusUseCase
    extends UseCase<DataState<MemberStatusModel>, String> {
  final CommunityRepository _communityRepository;

  GetMemberStatusUseCase(this._communityRepository);

  @override
  Future<DataState<MemberStatusModel>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      throw ArgumentError('Community ID cannot be null or empty');
    }
    return await _communityRepository.getMemberStatus(params);
  }
}
