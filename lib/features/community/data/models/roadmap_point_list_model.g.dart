// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_point_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoadmapPointListModelImpl _$$RoadmapPointListModelImplFromJson(
  Map<String, dynamic> json,
) => _$RoadmapPointListModelImpl(
  data: (json['data'] as List<dynamic>)
      .map((e) => RoadmapPointModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  hasNext: json['hasNext'] as bool,
);

Map<String, dynamic> _$$RoadmapPointListModelImplToJson(
  _$RoadmapPointListModelImpl instance,
) => <String, dynamic>{
  'data': instance.data,
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'hasNext': instance.hasNext,
};
