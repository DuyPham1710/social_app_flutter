// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchHistoryModelImpl _$$SearchHistoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$SearchHistoryModelImpl(
  id: json['_id'] as String,
  query: json['query'] as String?,
  resultCount: (json['resultCount'] as num?)?.toInt(),
  viewedUser: json['viewedUser'] == null
      ? null
      : UserModel.fromJson(json['viewedUser'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$SearchHistoryModelImplToJson(
  _$SearchHistoryModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  if (instance.query case final value?) 'query': value,
  if (instance.resultCount case final value?) 'resultCount': value,
  if (instance.viewedUser case final value?) 'viewedUser': value,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
