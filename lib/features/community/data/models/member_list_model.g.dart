// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberListModelImpl _$$MemberListModelImplFromJson(
  Map<String, dynamic> json,
) => _$MemberListModelImpl(
  data: (json['data'] as List<dynamic>)
      .map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  hasNext: json['hasNext'] as bool,
);

Map<String, dynamic> _$$MemberListModelImplToJson(
  _$MemberListModelImpl instance,
) => <String, dynamic>{
  'data': instance.data,
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'hasNext': instance.hasNext,
};
