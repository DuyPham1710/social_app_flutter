import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class CreateCommunityParams {
  final String name;
  final String? description;
  final String privacy;
  final String? type;
  final String? avatar;
  final String? coverImage;

  CreateCommunityParams({
    required this.name,
    this.description,
    required this.privacy,
    this.type,
    this.avatar,
    this.coverImage,
  });
}

class CreateCommunityUseCase
    implements UseCase<DataState<CommunityModel>, CreateCommunityParams> {
  final CommunityRepository _communityRepository;

  CreateCommunityUseCase(this._communityRepository);

  @override
  Future<DataState<CommunityModel>> call({CreateCommunityParams? params}) {
    return _communityRepository.createCommunity(
      name: params!.name,
      description: params.description,
      privacy: params.privacy,
      type: params.type,
      avatar: params.avatar,
      coverImage: params.coverImage,
    );
  }
}
