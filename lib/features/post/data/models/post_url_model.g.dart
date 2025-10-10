// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_url_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostUrlModelImpl _$$PostUrlModelImplFromJson(Map<String, dynamic> json) =>
    _$PostUrlModelImpl(
      id: json['_id'] as String,
      url: json['url'] as String,
      title: json['title'] as String?,
      order: (json['order'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PostUrlModelImplToJson(_$PostUrlModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'url': instance.url,
      'title': instance.title,
      'order': instance.order,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
