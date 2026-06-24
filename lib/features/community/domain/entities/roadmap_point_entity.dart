import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class RoadmapPointEntity {
  final String id;
  final String communityId;
  final String locationName;
  final double latitude;
  final double longitude;
  final int postCount;
  final List<String> postIds;
  final UserEntity? firstPostedBy;
  final DateTime? firstPostedAt;
  final DateTime? lastPostedAt;

  const RoadmapPointEntity({
    required this.id,
    required this.communityId,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.postCount,
    required this.postIds,
    this.firstPostedBy,
    this.firstPostedAt,
    this.lastPostedAt,
  });
}
