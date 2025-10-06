// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostListResponseImpl _$$PostListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PostListResponseImpl(
  data: (json['data'] as List<dynamic>)
      .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  hasNext: json['hasNext'] as bool?,
);

Map<String, dynamic> _$$PostListResponseImplToJson(
  _$PostListResponseImpl instance,
) => <String, dynamic>{
  'data': instance.data,
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'hasNext': instance.hasNext,
};
