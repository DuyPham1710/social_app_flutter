import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/community/data/models/roadmap_point_model.dart';

part 'community_roadmap_state.freezed.dart';

@freezed
class CommunityRoadmapState with _$CommunityRoadmapState {
  const factory CommunityRoadmapState.initial() = CommunityRoadmapInitial;
  const factory CommunityRoadmapState.loading() = CommunityRoadmapLoading;
  const factory CommunityRoadmapState.loaded(List<RoadmapPointModel> points) = CommunityRoadmapLoaded;
  const factory CommunityRoadmapState.error(String message) = CommunityRoadmapError;
}
