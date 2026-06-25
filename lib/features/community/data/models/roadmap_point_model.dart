import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/community/domain/entities/roadmap_point_entity.dart';

part 'roadmap_point_model.freezed.dart';
part 'roadmap_point_model.g.dart';

@freezed
class RoadmapPointModel with _$RoadmapPointModel implements RoadmapPointEntity {
  const RoadmapPointModel._();

  const factory RoadmapPointModel({
    @JsonKey(name: '_id') required String id,
    required String communityId,
    required String locationName,
    @JsonKey(name: 'locationCoordinates') dynamic locationCoordinates,
    required int postCount,
    @Default([]) List<String> postIds,
    UserModel? firstPostedBy,
    DateTime? firstPostedAt,
    DateTime? lastPostedAt,
  }) = _RoadmapPointModel;

  factory RoadmapPointModel.fromJson(Map<String, dynamic> json) =>
      _$RoadmapPointModelFromJson(json);

  @override
  double get latitude {
    if (locationCoordinates is Map<String, dynamic> &&
        locationCoordinates['coordinates'] is List) {
      return (locationCoordinates['coordinates'][1] as num).toDouble();
    }
    return 0.0;
  }

  @override
  double get longitude {
    if (locationCoordinates is Map<String, dynamic> &&
        locationCoordinates['coordinates'] is List) {
      return (locationCoordinates['coordinates'][0] as num).toDouble();
    }
    return 0.0;
  }
}
