// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivitySummaryModelImpl _$$ActivitySummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$ActivitySummaryModelImpl(
  activities: ActivityCountsModel.fromJson(
    json['activities'] as Map<String, dynamic>,
  ),
  summary: json['summary'] as String,
);

Map<String, dynamic> _$$ActivitySummaryModelImplToJson(
  _$ActivitySummaryModelImpl instance,
) => <String, dynamic>{
  'activities': instance.activities,
  'summary': instance.summary,
};

_$ActivityCountsModelImpl _$$ActivityCountsModelImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityCountsModelImpl(
  postCount: (json['postCount'] as num).toInt(),
  commentCount: (json['commentCount'] as num).toInt(),
  reactCount: (json['reactCount'] as num).toInt(),
  storyCount: (json['storyCount'] as num).toInt(),
);

Map<String, dynamic> _$$ActivityCountsModelImplToJson(
  _$ActivityCountsModelImpl instance,
) => <String, dynamic>{
  'postCount': instance.postCount,
  'commentCount': instance.commentCount,
  'reactCount': instance.reactCount,
  'storyCount': instance.storyCount,
};
