// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoadmapPointModelImpl _$$RoadmapPointModelImplFromJson(
  Map<String, dynamic> json,
) => _$RoadmapPointModelImpl(
  id: json['_id'] as String,
  communityId: json['communityId'] as String,
  locationName: json['locationName'] as String,
  locationCoordinates: json['locationCoordinates'],
  postCount: (json['postCount'] as num).toInt(),
  postIds:
      (json['postIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  firstPostedBy: json['firstPostedBy'] == null
      ? null
      : UserModel.fromJson(json['firstPostedBy'] as Map<String, dynamic>),
  firstPostedAt: json['firstPostedAt'] == null
      ? null
      : DateTime.parse(json['firstPostedAt'] as String),
  lastPostedAt: json['lastPostedAt'] == null
      ? null
      : DateTime.parse(json['lastPostedAt'] as String),
);

Map<String, dynamic> _$$RoadmapPointModelImplToJson(
  _$RoadmapPointModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'communityId': instance.communityId,
  'locationName': instance.locationName,
  'locationCoordinates': instance.locationCoordinates,
  'postCount': instance.postCount,
  'postIds': instance.postIds,
  'firstPostedBy': instance.firstPostedBy,
  'firstPostedAt': instance.firstPostedAt?.toIso8601String(),
  'lastPostedAt': instance.lastPostedAt?.toIso8601String(),
};
