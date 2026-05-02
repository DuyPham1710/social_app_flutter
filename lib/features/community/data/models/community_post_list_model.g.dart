// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_post_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityPostListModelImpl _$$CommunityPostListModelImplFromJson(
  Map<String, dynamic> json,
) => _$CommunityPostListModelImpl(
  data: (json['data'] as List<dynamic>)
      .map((e) => CommunityPostModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  hasNext: json['hasNext'] as bool,
);

Map<String, dynamic> _$$CommunityPostListModelImplToJson(
  _$CommunityPostListModelImpl instance,
) => <String, dynamic>{
  'data': instance.data,
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'hasNext': instance.hasNext,
};
