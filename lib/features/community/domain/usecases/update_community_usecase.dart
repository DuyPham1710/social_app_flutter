import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';

class UpdateCommunityParams {
  final String communityId;
  final String? name;
  final String? description;
  final String? privacy;
  final String? avatar;
  final String? coverImage;

  UpdateCommunityParams({
    required this.communityId,
    this.name,
    this.description,
    this.privacy,
    this.avatar,
    this.coverImage,
  });
}

class UpdateCommunityUseCase
    implements UseCase<DataState<CommunityModel>, UpdateCommunityParams> {
  final CommunityRepository _communityRepository;

  UpdateCommunityUseCase(this._communityRepository);

  @override
  Future<DataState<CommunityModel>> call({
    UpdateCommunityParams? params,
  }) async {
    return await _communityRepository.updateCommunity(
      communityId: params!.communityId,
      name: params.name,
      description: params.description,
      privacy: params.privacy,
      avatar: params.avatar,
      coverImage: params.coverImage,
    );
  }
}
