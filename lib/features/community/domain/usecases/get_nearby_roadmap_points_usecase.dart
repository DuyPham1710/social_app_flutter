import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/community/data/models/roadmap_point_list_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class GetNearbyRoadmapPointsUseCase
    implements UseCase<DataState<RoadmapPointListModel>, Map<String, dynamic>> {
  final CommunityRepository _communityRepository;

  GetNearbyRoadmapPointsUseCase(this._communityRepository);

  @override
  Future<DataState<RoadmapPointListModel>> call({Map<String, dynamic>? params}) {
    return _communityRepository.getNearbyRoadmapPoints(
      communityId: params!['communityId'],
      lat: params['lat'],
      lng: params['lng'],
      radius: params['radius'],
    );
  }
}
