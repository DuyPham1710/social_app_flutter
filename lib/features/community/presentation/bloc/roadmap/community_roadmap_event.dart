import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_roadmap_event.freezed.dart';

@freezed
class CommunityRoadmapEvent with _$CommunityRoadmapEvent {
  const factory CommunityRoadmapEvent.getRoadmapPoints({
    required String communityId,
    int? limit,
  }) = GetRoadmapPointsRequested;
  const factory CommunityRoadmapEvent.getNearbyRoadmapPoints({
    required String communityId,
    required double lat,
    required double lng,
    double? radius,
  }) = GetNearbyRoadmapPointsRequested;
}
