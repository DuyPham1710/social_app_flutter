// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostListModelImpl _$$PostListModelImplFromJson(Map<String, dynamic> json) =>
    _$PostListModelImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      hasNext: json['hasNext'] as bool?,
    );

Map<String, dynamic> _$$PostListModelImplToJson(_$PostListModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'hasNext': instance.hasNext,
    };
